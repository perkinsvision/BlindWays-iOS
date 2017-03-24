//
//  Route.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/1/16.
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
import CoreData

class Route: NSManagedObject {

    // MARK: Enum

    enum Direction: Int {
        case outbound = 0
        case inbound = 1

        var string: String {
            return "\(self.rawValue)"
        }
    }

    // Routes for the MBTA use the gtfs ID on nextbus, and other routes are using
    // the short name. This is a short term solution to make the system work with
    // MTBA and non-mbta routes, in the long run the value for this field should
    // be returned by the API.
    var nextBusID: String? {
        let nextBusID: String?
        if Agency.selectedAgency?.nextBusAgencyID == "mbta" {
            nextBusID = gtfsID.map { "\($0)" }
        } else {
            nextBusID = shortName
        }
        return nextBusID
    }

    // MARK: Import

    override class func rzv_externalPrimaryKey() -> String {
        return APIConstants.Common.ExternalKeys.id
    }

    override class func rzv_primaryKey() -> String {
        return "remoteID"
    }

    override func rzi_shouldImportValue(_ value: Any, forKey key: String) -> Bool {
        if key == APIConstants.Routes.ExternalKeys.directions {
            if let dict = value as? [String: AnyObject] {
                directions = dict
                return false
            }
        }

        return true
    }

}
