//
//  LocationViewModelTests.swift
//  BlindWaysTests
//
//  Created by Zev Eisenberg on 7/18/16.
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
import CoreLocation

typealias Distance = LocationViewModel.Distance
typealias Accuracy = LocationViewModel.Accuracy

class LocationViewModelTests: XCTestCase {

    func testDistanceImperial() {
        let en_US = Locale(identifier: "en_US")
        let unknown = Distance.unknown
        XCTAssertEqual(unknown.localizedTitle(locale: en_US), "")

        let m0 = Distance.meters(0)
        XCTAssertEqual(m0.localizedTitle(locale: en_US), "You are within 15 ft.")

        let ft1 = Distance.meters(1 / LocationConstants.feetPerMeter)
        XCTAssertEqual(ft1.localizedTitle(locale: en_US), "You are within 15 ft.")

        let ft45 = Distance.meters(45 / LocationConstants.feetPerMeter)
        XCTAssertEqual(ft45.localizedTitle(locale: en_US), "You are within 50 ft.")

        let ft51 = Distance.meters(51 / LocationConstants.feetPerMeter)
        XCTAssertEqual(ft51.localizedTitle(locale: en_US), "You are within 100 ft.")

        let ft150 = Distance.meters(150 / LocationConstants.feetPerMeter)
        XCTAssertEqual(ft150.localizedTitle(locale: en_US), "You are within 200 ft.")

        let ft201 = Distance.meters(201 / LocationConstants.feetPerMeter)
        XCTAssertEqual(ft201.localizedTitle(locale: en_US), "You are within 500 ft.")

        let ft528 = Distance.meters(528 / LocationConstants.feetPerMeter)
        XCTAssertEqual(ft528.localizedTitle(locale: en_US), "You are 0.1 mi away.")

        let m10_000 = Distance.meters(10_000)
        XCTAssertEqual(m10_000.localizedTitle(locale: en_US), "You are 6.2 mi away.")

        let m100_000 = Distance.meters(100_000)
        XCTAssertEqual(m100_000.localizedTitle(locale: en_US), "You are 62 mi away.")
    }

    func testDistanceMetric() {
        let en_CA = Locale(identifier: "en_CA")
        let unknown = Distance.unknown
        XCTAssertEqual(unknown.localizedTitle(locale: en_CA), "")

        let m0 = Distance.meters(0)
        XCTAssertEqual(m0.localizedTitle(locale: en_CA), "You are within 5 m.")

        let m1point5 = Distance.meters(1.5)
        XCTAssertEqual(m1point5.localizedTitle(locale: en_CA), "You are within 5 m.")

        let m12 = Distance.meters(12)
        XCTAssertEqual(m12.localizedTitle(locale: en_CA), "You are within 15 m.")

        let m23 = Distance.meters(23)
        XCTAssertEqual(m23.localizedTitle(locale: en_CA), "You are within 30 m.")

        let m50 = Distance.meters(50)
        XCTAssertEqual(m50.localizedTitle(locale: en_CA), "You are within 60 m.")

        let m61 = Distance.meters(61)
        XCTAssertEqual(m61.localizedTitle(locale: en_CA), "You are 0.1 km away.")

        let m100 = Distance.meters(100)
        XCTAssertEqual(m100.localizedTitle(locale: en_CA), "You are 0.1 km away.")

        let m314 = Distance.meters(314)
        XCTAssertEqual(m314.localizedTitle(locale: en_CA), "You are 0.3 km away.")

        let m10_000 = Distance.meters(10_000)
        XCTAssertEqual(m10_000.localizedTitle(locale: en_CA), "You are 10 km away.")

        let m31_415 = Distance.meters(31_415)
        XCTAssertEqual(m31_415.localizedTitle(locale: en_CA), "You are 31 km away.")
    }

    func testAccuracy() {
        let locationWithAccuracy = { (accuracy: CLLocationAccuracy) -> CLLocation in
            return CLLocation(
                coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                altitude: 0,
                horizontalAccuracy: accuracy,
                verticalAccuracy: 0,
                timestamp: Date())
        }

        XCTAssertEqual(Accuracy(location: locationWithAccuracy(3)), Accuracy.good)
        XCTAssertEqual(Accuracy(location: locationWithAccuracy(9.9999)), Accuracy.good)
        XCTAssertEqual(Accuracy(location: locationWithAccuracy(10.5)), Accuracy.fair)
        XCTAssertEqual(Accuracy(location: locationWithAccuracy(29)), Accuracy.fair)
        XCTAssertEqual(Accuracy(location: locationWithAccuracy(29.9999)), Accuracy.fair)
        XCTAssertEqual(Accuracy(location: locationWithAccuracy(30)), Accuracy.bad)
        XCTAssertEqual(Accuracy(location: locationWithAccuracy(31)), Accuracy.bad)
    }

}
