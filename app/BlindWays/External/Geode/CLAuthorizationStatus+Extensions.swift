//
//  CLAuthorizationStatus+Extensions.swift
//  BlindWays
//
//  Created by John Watson on 2/1/16.
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

extension CLAuthorizationStatus: CustomStringConvertible {

    public var description: String {
        switch self {
        case .authorizedAlways:
            return ".AuthorizedAlways"

        case .authorizedWhenInUse:
            return ".AuthorizedWhenInUse"

        case .restricted:
            return ".Restricted"

        case .denied:
            return ".Denied"

        case .notDetermined:
            return ".NotDetermined"
        }
    }

}
