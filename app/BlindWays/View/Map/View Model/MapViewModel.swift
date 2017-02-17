//
//  MapViewModel.swift
//  BlindWays
//
//  Created by Zev Eisenberg on 9/22/16.
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

import CoreLocation
import Swiftilities

struct MapViewModel {

    let title = UIStrings.mapTitle.string

    let stop: Stop
    let initialUserLocation: CLLocation

    /// The farthest possible points to the north, east, south, and west where the user might start,
    /// based on their initial location and horizontal accuracy.
    var userLocationExtrema: [CLLocationCoordinate2D] {
        let coordinate = initialUserLocation.coordinate

        let accuracy = initialUserLocation.horizontalAccuracy
        // If the accuracy is negative, it is invalid, so just return an array with the original coordinate
        guard accuracy >= 0 else {
            return [coordinate]
        }

        let northPoint = MapViewModel.shift(coordinate: coordinate, shiftNorth: accuracy, shiftEast: 0.0)
        let eastPoint = MapViewModel.shift(coordinate: coordinate, shiftNorth: 0.0, shiftEast: accuracy)
        let southPoint = MapViewModel.shift(coordinate: coordinate, shiftNorth: -accuracy, shiftEast: 0.0)
        let westPoint = MapViewModel.shift(coordinate: coordinate, shiftNorth: 0.0, shiftEast: -accuracy)

        return [
            northPoint,
            eastPoint,
            southPoint,
            westPoint,
        ]
    }

}

private extension MapViewModel {

    static func shift(coordinate: CLLocationCoordinate2D, shiftNorth: CLLocationDistance, shiftEast: CLLocationDistance) -> CLLocationCoordinate2D {
        // formula via http://gis.stackexchange.com/a/2980

        let earthRadius = CLLocationDistance(6.3674447E6)

        let dLat = shiftNorth / earthRadius
        let dLon = shiftEast / (earthRadius * cos(M_PI * coordinate.latitude / 180.0))

        let newLatitude = coordinate.latitude + (dLat * (180.0 / M_PI))
        let newLongitude = coordinate.longitude + (dLon * (180.0 / M_PI))

        return CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
    }

}
