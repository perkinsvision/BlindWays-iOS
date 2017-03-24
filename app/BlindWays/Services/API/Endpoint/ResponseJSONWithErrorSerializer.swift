//
//  ResponseJSONWithErrorSerializer.swift
//  BlindWays
//
//  Created by Zev Eisenberg on 8/8/16.
//  Copyright© 2016 Perkins School for the Blind
//
//  All "Perkins Bus Stop App" Software is licensed under Apache Version 2.0.
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Alamofire

extension DataRequest {

    func responseJSONWithError(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<Any>) -> Void) -> Self {

        let serializer = DataRequest.jsonResponseWithErrorSerializer(options: options)
        return self.response(
            queue: queue,
            responseSerializer: serializer,
            completionHandler: completionHandler
        )
    }

    static func jsonResponseWithErrorSerializer(options: JSONSerialization.ReadingOptions = .allowFragments) -> DataResponseSerializer<Any> {

        struct ErrorKeys {

            static let reason = "reason"
            static let readableMessage = "readable_message"

        }

        return DataResponseSerializer { (_, response, data, error) -> Result<Any> in

            if let response = response, response.statusCode == 204 { return .success(NSNull()) }

            guard let validData = data, validData.count > 0 else {
                return .failure(ServiceError.error(with: .jsonSerializationFailed))
            }

            let json: Any
            do {
                json = try JSONSerialization.jsonObject(with: validData, options: options)
            } catch {
                return .failure(error)
            }

            if let _ = error {
                if let jsonDict = json as? [AnyHashable: Any], let reason = jsonDict[ErrorKeys.reason] as? String {
                    let readableMessage = jsonDict[ErrorKeys.readableMessage] as? String
                    let error = ServiceError.serverError(reason: reason, serverReadableFallback: readableMessage)
                    return .failure(error)
                } else {
                    return .failure(ServiceError.error(with: .jsonSerializationFailed))
                }
            } else {
                return .success(json)
            }
        }
    }

}
