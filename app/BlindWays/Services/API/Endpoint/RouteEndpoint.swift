//
//  RouteEndpoint.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/21/16.
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
import CoreLocation

// MARK: Endpoint

enum Routes {

    case search(searchText: String)
    case stops(routeID: Int64, direction: Route.Direction, destination: String)

    struct Constants {

    }
}

extension Routes: APIEndpoint {

    var encoding: Alamofire.ParameterEncoding {
        return Alamofire.URLEncoding.default
    }

    var method: Alamofire.HTTPMethod {
        return .get
    }

    var path: String {
        switch self {
        case .search:
            return "/routes/search"
        case .stops(let routeID, _, _):
            return "/routes/\(routeID)/stops"
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .search(let searchText):
            return [
                "route_match": searchText,
            ]
        case .stops(_, let direction, let destination):
            return [
                "direction": direction.string,
                "destination": destination,
            ]
        }
    }
}

// MARK: Client

extension APIClient {

    typealias SearchRoutesCompletion = (Alamofire.Result<[Route]>) -> Void

    @discardableResult func searchRoutes(_ searchText: String, completion: @escaping SearchRoutesCompletion) -> DataRequest {
        let endpoint = Routes.search(searchText: searchText)
        let request = self.request(endpoint)
        request.responseImportedCollection(completion)

        return request
    }

    typealias RouteStopsCompletion = (Alamofire.Result<[Stop]>) -> Void

    @discardableResult func stopsForRoute(_ routeID: Int64, direction: Route.Direction, destination: String, completion: @escaping RouteStopsCompletion) -> DataRequest {
        let endpoint = Routes.stops(routeID: routeID, direction: direction, destination: destination)
        let request = self.request(endpoint)
        request.responseImportedCollection(completion)

        return request
    }

}
