//
//  LocationRangeMonitor.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 6/27/16.
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
import CoreLocation
import Swiftilities

class LocationRangeMonitor {

    struct Constants {

        // The range threshold to trigger a warning
        static let warnDistanceMeters = 35.0

        // Only trigger changes if delta between last and current location is greater than this value
        // Used to account for jitter in location reporting
        static let deltaBufferMeters = 5.0

        // Horizontal accuracy must be less than this value in order to be counted towards ranging
        static let horizontalAccuracyUpperLimit = 30.0
    }

    fileprivate let target: CLLocation
    fileprivate var last: CLLocation?
    fileprivate var isInRange: Bool = false

    var onExitRange: Block?

    init(target: CLLocation) {
        self.target = target
    }

    func process(_ location: CLLocation) {
        Log.verbose("Location -- ha: \(location.horizontalAccuracy) va: \(location.verticalAccuracy) age: \(location.timestamp) distance: \(target.distance(from: location))")
        guard location.horizontalAccuracy <= Constants.horizontalAccuracyUpperLimit else {
            Log.verbose("Location has insufficient accuracy \(location.horizontalAccuracy), aborting")
            return
        }

        let inRange = target.checkIsInRange(location)

        if let last = last {

            // Only deal with each subsequent location in buffer increment in order
            // to avoid rapid triggering of warn due to GPS jitter
            if last.distance(from: location) > Constants.deltaBufferMeters {

                // Only trigger warning if we were in range and now are not
                if isInRange && !inRange {
                    onExitRange?()
                }

                isInRange = inRange
                self.last = location
            }

        } else {
            isInRange = inRange
            self.last = location
        }

    }

}

private extension CLLocation {

    func checkIsInRange(_ location: CLLocation) -> Bool {
        return self.distance(from: location) < LocationRangeMonitor.Constants.warnDistanceMeters
    }

}
