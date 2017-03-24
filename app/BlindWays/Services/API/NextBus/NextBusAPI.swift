//
//  NextBusAPI.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/30/16.
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

import Foundation
import Alamofire

//var URLRequest: NSMutableURLRequest { get }

enum NextBus {

    static let baseURL = URL(string: "http://webservices.nextbus.com/service/publicXMLFeed")!

    case predictions(agency: String, routeTag: String, stopTag: String)

}

extension NextBus: APIEndpoint {

    var encoding: Alamofire.ParameterEncoding {
        return URLEncoding.default
    }

    var method: Alamofire.HTTPMethod {
        return .get
    }

    var path: String {
        return ""
    }

    var parameters: [String : Any]? {
        switch self {
        case .predictions(let agency, let routeTag, let stopTag):
            return [
                "command": "predictions",
                "a": agency,
                "r": routeTag,
                "s": stopTag,
            ]
        }
    }

}

extension APIClient {

    typealias NextBusPredictionsCompletion = (Alamofire.Result<[NextBusPrediction]>) -> Void

    func predictionsForStop(_ stopTag: String, routeTags: [String], agency: String, completion: @escaping NextBusPredictionsCompletion) -> [DataRequest] {
        let dispatchGroup = DispatchGroup()
        var requests = [DataRequest]()
        var results = [NextBusPrediction]()
        var errors = [Error]()

        for routeTag in routeTags {
            dispatchGroup.enter()
            let endpoint = NextBus.predictions(agency: agency, routeTag: routeTag, stopTag: stopTag)
            let request = manager.request(NextBus.baseURL, endpoint: endpoint).responseData(completionHandler: { (response) in

                if let data = response.data, response.result.isSuccess {
                    results.append(contentsOf: NextBusPrediction.predictionsFromXML(data: data))
                } else if let error = response.result.error {
                    errors.append(error)
                }

                dispatchGroup.leave()
            })

            requests.append(request)
        }

        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            if let error = errors.last {
                completion(.failure(error))
            } else {
                completion(.success(results.sorted { $0.minutes < $1.minutes }))
            }
        })

        return requests
    }

}
