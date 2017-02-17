//
//  Stop+CoreDataProperties.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/9/16.
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
import CoreLocation

extension Stop {

    @NSManaged var desc: String?
    @NSManaged var gtfsID: String?
    @NSManaged var isSaved: Bool
    @NSManaged var location: CLLocation
    @NSManaged var name: String
    @NSManaged var needsMoreClues: Bool
    @NSManaged var remoteID: Int64
    @NSManaged var routes: NSOrderedSet?
    @NSManaged var clueSet: ClueSet?
    @NSManaged var direction: NSNumber? // Needs to be NSNumber so it can be optional

}
