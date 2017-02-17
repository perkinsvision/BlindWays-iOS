//
//  RouteViewModel.swift
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

class RouteViewModel {

    let route: Route
    let direction: Route.Direction
    let destination: String

    init(route: Route, direction: Route.Direction, destination: String) {
        self.route = route
        self.direction = direction
        self.destination = destination
    }

    var localizedTitle: String {
        return "\(route.name) - \(direction.localizedTitle)"
    }

    var localizedSubtitle: String {
        return UIStrings.routeToDestinationFormat(destination).string
    }

}
