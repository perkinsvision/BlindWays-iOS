//
//  LocationExtensions.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 4/5/16.
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

struct LocationConstants {

    static let metersPerKilometer: Double = 1000.0
    static let metersPerMile: Double = 1609.34
    static let metersPerFoot: Double = 0.3048
    static let feetPerMeter: Double = 3.28084
    static let feetPerMile: Double = 5280.0

}

extension CLLocation {

    var hasValidCoordinate: Bool {
        return CLLocationCoordinate2DIsValid(self.coordinate)
    }

}
