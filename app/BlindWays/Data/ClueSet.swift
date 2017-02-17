//
//  ClueSet.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 4/12/16.
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

class ClueType: NSObject, NSCoding, RZImportable {

    static let otherType = "OTHER"

    var type: String
    var title: String
    var subTypes: [ClueType]?
    var parentType: ClueType?
    var label: String

    override init() {
        self.type = ""
        self.title = ""
        self.label = ""
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(type, forKey: "type")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(label, forKey: "label")
        if let subTypes = subTypes {
            aCoder.encode(subTypes, forKey: "subTypes")
        }
        if let parentType = parentType {
            aCoder.encode(parentType, forKey: "parentType")
        }
    }

    required init?(coder aDecoder: NSCoder) {
        if let type = aDecoder.decodeObject(forKey: "type") as? String,
            let title = aDecoder.decodeObject(forKey: "title") as? String,
            let label = aDecoder.decodeObject(forKey: "label") as? String {
            self.type = type
            self.title = title
            self.label = label
            self.subTypes = aDecoder.decodeObject(forKey: "subTypes") as? [ClueType]
            self.parentType = aDecoder.decodeObject(forKey: "parentType") as? ClueType
        } else {
            return nil
        }
    }

    class func rzv_shouldAlwaysCreateNewObjectOnImport() -> Bool {
        return true
    }

    func rzi_shouldImportValue(_ value: Any, forKey key: String) -> Bool {
        if let value = value as? [[String: Any]], key == "sub_types" {
            if let types = ClueType.rzi_objects(from: value) as? [ClueType] {
                self.subTypes = types
                for type in types {
                    type.parentType = self
                }
                return false
            }
            return true
        }

        return true
    }

    var isOtherType: Bool {
        return type == ClueType.otherType
    }

    var topLevelClueType: ClueType {
        return parentType ?? self
    }

    func matchingSubType(_ matchType: String) -> ClueType? {
        if self.type == matchType {
            return self
        }

        if let subTypes = subTypes {
            for subType in subTypes {
                if subType.type == matchType {
                    return subType
                }
            }
        }

        return nil
    }

    static func lookUpClueType(identifier: String, busStop: Bool) -> ClueType? {
        if let config = RemoteConfig.defaultConfig(),
            let landmarkTypes = config.landmarkClueTypes,
            let busStopTypes = config.busStopClueTypes {
            let searchList = busStop ? busStopTypes : landmarkTypes
            for type in searchList {
                if let match = type.matchingSubType(identifier), match.type == identifier {
                    return match
                }
            }
        }

        return nil
    }

}

protocol ClueRepresentable {

    var label: String { get }
    var hint: String? { get }
    var isBusStopSign: Bool { get }
    var onGrassOrDirt: Bool { get }
    var awayFromCurb: Bool { get }

}

class Clue: NSObject, NSCoding, RZImportable, ClueRepresentable {

    var remoteID: Int64
    var type: String
    var label: String
    var hint: String?
    var confirmed: Bool = false
    var isBusStopSign: Bool = false
    var onGrassOrDirt: Bool = false
    var awayFromCurb: Bool = false

    override init() {
        self.remoteID = 0
        self.type = ""
        self.label = ""
        self.confirmed = false
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(remoteID, forKey: "remoteID")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(label, forKey: "label")
        aCoder.encode(confirmed, forKey: "confirmed")
        aCoder.encode(isBusStopSign, forKey: "isBusStopSign")
        aCoder.encode(onGrassOrDirt, forKey: "onGrassOrDirt")
        aCoder.encode(awayFromCurb, forKey: "awayFromCurb")
        if let hint = hint {
            aCoder.encode(hint, forKey: "hint")
        }
    }

    required init?(coder aDecoder: NSCoder) {
        if let type = aDecoder.decodeObject(forKey: "type") as? String,
            let label = aDecoder.decodeObject(forKey: "label") as? String,
            let confirmed = aDecoder.decodeObject(forKey: "confirmed") as? Bool,
            let isBusStopSign = aDecoder.decodeObject(forKey: "isBusStopSign") as? Bool,
            let onGrassOrDirt = aDecoder.decodeObject(forKey: "onGrassOrDirt") as? Bool,
            let awayFromCurb = aDecoder.decodeObject(forKey: "awayFromCurb") as? Bool {

            self.remoteID = aDecoder.decodeInt64(forKey: "remoteID")
            self.type = type
            self.label = label
            self.hint = aDecoder.decodeObject(forKey: "hint") as? String
            self.confirmed = confirmed
            self.isBusStopSign = isBusStopSign
            self.onGrassOrDirt = onGrassOrDirt
            self.awayFromCurb = awayFromCurb
        } else {
            return nil
        }
    }

    // MARK: Import

    class func rzi_customMappings() -> [String : String] {
        return [
            APIConstants.Common.ExternalKeys.id: "remoteID",
        ]
    }

}

class ClueSet: NSManagedObject {

    override class func rzv_shouldAlwaysCreateNewObjectOnImport() -> Bool {
        return true
    }

    override class func rzi_ignoredKeys() -> [String] {
        return [
            APIConstants.Common.ExternalKeys.id,
            APIConstants.ClueSets.ExternalKeys.helpfulCount,
        ]
    }

    override func rzi_importValues(fromDict dict: [String : Any]) {
        super.rzi_importValues(fromDict: dict)
        busStopSign?.isBusStopSign = true
    }

    override class func rzi_nestedObjectKeys() -> [String] {
        return [
            "leftOfSignFar",
            "leftOfSignNear",
            "busStopSign",
            "rightOfSignNear",
            "rightOfSignFar",
        ]
    }

}
