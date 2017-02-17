//
//  StopViewModel.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/17/16.
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

struct StopViewModel: InfoItem {

    static let maxDisplayedRoutes = 5

    let stop: Stop
    let showDirection: Bool
    let showRoutes: Bool
    let iconImage = Asset.icnBus.image
    let hasChildren = true
    let iconLabel: String? = nil
    let accessibilityHint: String? = nil

    init(stop: Stop, showDirection: Bool, showRoutes: Bool = true) {
        self.stop = stop
        self.showDirection = showDirection
        self.showRoutes = showRoutes
    }

    // MARK: Properties

    var localizedTitle: String {
        if let directionNumber = stop.direction as? Int, let direction = Route.Direction(rawValue: directionNumber), showDirection {
            return "\(stop.name) - \(direction.localizedTitle)"
        } else {
            return stop.name
        }
    }

    var localizedSubtitle: String? {
        guard showRoutes else {
            return nil
        }

        let routeNames = stop.sortedRouteNames
        if routeNames.count <= StopViewModel.maxDisplayedRoutes {
            // Rule of threes: also implemented in StopDetailViewModel.
            // Refactor if you need this in a third place.
            let routeLabel = routeNames.count == 1 ? UIStrings.stopsCellRouteTitle.string : UIStrings.stopsCellRoutesTitle.string
            return "\(routeLabel) \(routeNames.joined(separator: ", "))".uppercased()
        } else {
            return UIStrings.stopsCellRoutesTitleFormat(routeNames.count).string.uppercased()
        }
    }

    var localizedSupplementalText: String? {
        if stop.needsMoreClues {
            return UIStrings.stopsCellNeedsMoreCluesTitle.string
        } else {
            return nil
        }
    }

}
