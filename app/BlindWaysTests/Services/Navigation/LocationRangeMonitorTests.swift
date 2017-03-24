//
//  LocationRangeMonitorTests.swift
//  BlindWaysTests
//
//  Created by Nicholas Bonatsakis on 6/28/16.
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

import XCTest
@testable import BlindWays
import Nimble
import CoreLocation

class LocationRangeMonitorTests: XCTestCase {

    fileprivate struct TestLocations {
        static let milkStreet = CLLocation(latitude: 42.357004, longitude: -71.057619)
        static let southStation = CLLocation(latitude: 42.352586, longitude: -71.0554405)
    }

    func testLeaveTarget() {
        let target = TestLocations.milkStreet
        let farFromTarget = TestLocations.southStation
        let monitor = LocationRangeMonitor(target: target)

        // start at target
        monitor.process(target)

        var done = false
        monitor.onExitRange = {
            done = true
        }

        // move away from target
        monitor.process(farFromTarget)

        expect(done).toEventually(beTruthy())
    }

    func testLeaveTargetIncrementally() {
        let target = TestLocations.milkStreet
        let monitor = LocationRangeMonitor(target: target)

        // start at target
        monitor.process(target)

        var done = false
        monitor.onExitRange = {
            done = true
        }

        DispatchQueue.global(qos: .default).async {
            var movedLocation = target
            for _ in 1...50 {
                monitor.process(movedLocation)
                movedLocation = movedLocation.moveByMetersLat(meters: 1)
            }
        }

        expect(done).toEventually(beTruthy())
    }

    func testArriveAtTarget() {
        let target = TestLocations.milkStreet
        let farFromTarget = TestLocations.southStation
        let monitor = LocationRangeMonitor(target: target)

        // start far from target
        monitor.process(farFromTarget)

        monitor.onExitRange = {
            fail("Exit range should not be called when entering the target region")
        }

        // arrive at target
        monitor.process(target)
    }

}

struct TestLocationConstants {

    // Lat coordinate delta -> 1 meter
    static let latDeltaToMeter: Double = 0.000009002505307

    // Lng coordinate delta -> 1 meter
    static let lngDeltaToMeter: Double = 0.00001213798166

}

extension CLLocation {

    func moveByMetersLat(meters: Double) -> CLLocation {
        return CLLocation(latitude: coordinate.latitude + (TestLocationConstants.latDeltaToMeter * meters), longitude: coordinate.longitude)
    }

    func moveByMetersLng(meters: Double) -> CLLocation {
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude + (TestLocationConstants.lngDeltaToMeter * meters))
    }

}
