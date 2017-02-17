//
//  RouteStopsViewModel.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/22/16.
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

class RouteStopsViewModel: StopsListViewModel {

    let route: Route
    let direction: Route.Direction
    let destination: String

    init(client: APIClient, route: Route, direction: Route.Direction, destination: String) {
        self.route = route
        self.direction = direction
        self.destination = destination
        super.init(client: client)
    }

    // MARK: Properties

    override var localizedTitle: String {
        return UIStrings.routeStopsTitleFormat(route.name, destination).string
    }

    override var analyticsPageName: String {
        return "Route"
    }

    // MARK: Refresh

    override var allowsManualRefresh: Bool {
        return false
    }

    override func refresh(_ completion: @escaping BaseFetchedListViewModelCompletion) {
        state = .refreshing

        client.stopsForRoute(route.remoteID, direction: direction, destination: destination) { result in
            if let stops = result.value, result.isSuccess {
                self.state = .loaded
                let viewModels = stops.map({ StopViewModel(stop: $0, showDirection: false, showRoutes: false) })
                self.listObjects = viewModels
                completion(.success(viewModels))
            } else if let error = result.error {
                self.state = .error(error: error)
                completion(.failure(error))
            }
        }
    }

}
