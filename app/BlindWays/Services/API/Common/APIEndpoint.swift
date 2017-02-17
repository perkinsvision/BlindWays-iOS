//
//  APIEndpoint.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/7/16.
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
import Swiftilities

protocol APIEndpoint {

    /// The encoding to use (e.g. "application/json") for any request parameters.
    var encoding: Alamofire.ParameterEncoding { get }

    /// The HTTP method to use (e.g. "GET").
    var method: Alamofire.HTTPMethod { get }

    /// The endpoint's path, relative to the base URL.
    var path: String { get }

    /// The parameters to encode
    var parameters: [String : Any]? { get }

    /// Whether or not to prepend agency to the path
    var prependAgency: Bool { get }
}

extension APIEndpoint {
    var prependAgency: Bool {
        return true
    }
}

extension Alamofire.SessionManager {

    func request(_ config: APIConfiguration, endpoint: APIEndpoint, headers: [String: String]? = nil) -> DataRequest {
        let url: URL
        if endpoint.prependAgency, let agencyID = config.agencyID {
            url = config.env.baseURL.appendingPathComponent("agencies/\(agencyID)").appendingPathComponent(endpoint.path)
        } else {
            url = config.env.baseURL.appendingPathComponent(endpoint.path)
        }

        var newHeaders = headers ?? [String: String]()
        if let token = config.authToken {
            newHeaders[APIClient.Constants.Headers.authName] = String(format: APIClient.Constants.Headers.bearerValueFormat, token)
        }

        let request = self.request(url, method: endpoint.method, parameters: endpoint.parameters, encoding: endpoint.encoding, headers: newHeaders)

        Log.info("Executing API Request: \(request.request?.url)")

        return request
    }

    func request(_ baseURL: URL, endpoint: APIEndpoint, headers: [String: String]? = nil) -> DataRequest {
        let url = endpoint.path.characters.count > 0 ? baseURL.appendingPathComponent(endpoint.path) : baseURL
        let request = self.request(url, method: endpoint.method, parameters: endpoint.parameters, encoding: endpoint.encoding, headers: headers)

        Log.info("Executing API Request: \(request.request?.url)")

        return request
    }

}
