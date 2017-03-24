//
//  RouteSearchViewModel.swift
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
import Swiftilities

final class RouteSearchViewModel: BaseListViewModel<RouteViewModel> {

    var searchText: String = ""

    override init(client: APIClient) {
        super.init(client: client)
    }

    override func refresh(_ completion: @escaping BaseFetchedListViewModelCompletion) {
        guard !state.isRefreshing else {
            Log.info("Request in progress, aborting")
            return
        }

        state = .refreshing

        client.searchRoutes(searchText) { result in
            if let routes = result.value, result.isSuccess {
                var viewModels = [RouteViewModel]()
                for route in routes {
                    viewModels += RouteSearchViewModel.routeViewModels(from: route, direction: .inbound)
                    viewModels += RouteSearchViewModel.routeViewModels(from: route, direction: .outbound)
                }

                self.listObjects = viewModels
                self.state = .loaded
                completion(.success(viewModels))
            } else if let error = result.error {
                self.state = .error(error: error)
                completion(.failure(error))
            }
        }
    }

    func routeStopsViewModel(for index: Int) -> RouteStopsViewModel {
        let routeViewModel = listObjects[index]
        return RouteStopsViewModel(client: client, route: routeViewModel.route, direction: routeViewModel.direction, destination: routeViewModel.destination)
    }
}

private extension RouteSearchViewModel {

    static func routeViewModels(from route: Route, direction: Route.Direction) -> [RouteViewModel] {
        var viewModels = [RouteViewModel]()
        if let destinations = route.directions?[direction.string] as? [String], destinations.count > 0 {
            for destination in destinations {
                viewModels.append(RouteViewModel(route: route, direction: direction, destination: destination))
            }
        }
        return viewModels
    }

}
