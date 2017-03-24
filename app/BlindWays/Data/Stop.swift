//
//  Stop.swift
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
import RZImport
import RZVinyl
import CoreLocation

class Stop: NSManagedObject {

    // MARK: Import

    override class func rzv_externalPrimaryKey() -> String {
        return APIConstants.Common.ExternalKeys.id
    }

    override class func rzv_primaryKey() -> String {
        return "remoteID"
    }

    override class func rzi_customMappings() -> [String : String] {
        return [
            APIConstants.Stops.ExternalKeys.desc: "desc",
        ]
    }

    override class func rzi_ignoredKeys() -> [String] {
        return [
            // Ignore location, as we import it explicitly in rzi_importValuesFromDict
            APIConstants.Stops.ExternalKeys.location,
            APIConstants.Stops.ExternalKeys.latestReportedUserLocation,
        ]
    }

    override class func rzi_nestedObjectKeys() -> [String] {
        return ["clueSet"]
    }

    override func rzi_importValues(fromDict dict: [String : Any], withMappings mappings: [String : String]?) {
        super.rzi_importValues(fromDict: dict, withMappings: mappings)

        if let locDict = dict[APIConstants.Stops.ExternalKeys.location] as? [String: Any],
            let lat = locDict[APIConstants.Common.ExternalKeys.lat] as? Double,
            let lng = locDict[APIConstants.Common.ExternalKeys.lng] as? Double {
                self.location = CLLocation(latitude: lat, longitude: lng)
        }
    }

    override func rzi_shouldImportValue(_ value: Any, forKey key: String) -> Bool {
        if let routesArr = value as? [[String: Any]], key == APIConstants.Stops.ExternalKeys.routes {
            let routes = Route.rzi_objects(from: routesArr)
            self.routes = NSOrderedSet(array: routes)
            return false
        }

        return super.rzi_shouldImportValue(value, forKey: key)
    }

}

extension Stop {

    var sortedRouteNames: [String] {
        let routeNames: [String] = routes?.map {
            ($0 as AnyObject).name
            } ?? []
        return routeNames.sorted {
            $0.compare($1, options: .numeric) == .orderedAscending
        }
    }

}
