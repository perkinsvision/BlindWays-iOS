//
//  Agency.swift
//  BlindWays
//
//  Created by Fabien Legoupillot on 1/19/17.
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

class Agency: NSManagedObject {

    // MARK: Import

    override class func rzv_externalPrimaryKey() -> String {
        return APIConstants.Common.ExternalKeys.id
    }

    override class func rzv_primaryKey() -> String {
        return "remoteID"
    }

    override class func rzi_ignoredKeys() -> [String] {
        return [
            APIConstants.Agencies.ExternalKeys.faceUrl,
            APIConstants.Agencies.ExternalKeys.fareUrl,
            APIConstants.Agencies.ExternalKeys.phone,
            APIConstants.Agencies.ExternalKeys.lang,
            APIConstants.Agencies.ExternalKeys.timezone,
            APIConstants.Agencies.ExternalKeys.url,
            APIConstants.Agencies.ExternalKeys.gtfsID,
            APIConstants.Agencies.ExternalKeys.state,
        ]
    }

    override func rzi_importValues(fromDict dict: [String : Any], withMappings mappings: [String : String]?) {
        super.rzi_importValues(fromDict: dict, withMappings: mappings)
        if let lat = parseDouble(from: dict[APIConstants.Common.ExternalKeys.lat]),
            let lng = parseDouble(from: dict[APIConstants.Common.ExternalKeys.lng]) {
            self.location = CLLocation(latitude: lat, longitude: lng)
        }
    }

    override func rzi_shouldImportValue(_ value: Any, forKey key: String) -> Bool {
        switch key {
        case APIConstants.Common.ExternalKeys.lat, APIConstants.Common.ExternalKeys.lng:
            // skipping this to reduce console noise as the location is imported from these keys in rzi_importValues
            return false
        default:
            return super.rzi_shouldImportValue(value, forKey: key)
        }
    }

}

extension Agency {

    @nonobjc static var selectedAgency: Agency? {
        guard let agencies = Agency.rzv_all() as? [Agency], let agency = agencies.filter({ $0.isSelected }).first else {
            return nil
        }

        return agency
    }

    var localizedTitle: String {
        let cityValue = city ?? ""
        let nameValue = name ?? ""

        if !cityValue.isEmpty && !nameValue.isEmpty {
            return "\(cityValue) - \(nameValue)"
        } else if !cityValue.isEmpty {
            return cityValue
        } else if !nameValue.isEmpty {
            return nameValue
        } else {
            return ""
        }
    }

}

private extension Agency {

    // The API is returning the lat and lng as string values right now
    // but we don't want the parsing to break when it gets fixed
    // so we're preferring a direct cast, then falling back on casting 
    // to string then init-ing from the string
    func parseDouble(from value: Any?) -> Double? {
        let parsed: Double?
        if let double = value as? Double {
            parsed = double
        } else if let string = value as? String {
            parsed = Double(string)
        } else {
            parsed = nil
        }
        return parsed
    }

}
