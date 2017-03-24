//
//  ClueSet+CoreDataProperties.swift
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

extension ClueSet {

    @NSManaged var createdTimestamp: Date
    @NSManaged var lastModifiedTimestamp: Date
    @NSManaged var leftOfSignFar: Clue?
    @NSManaged var leftOfSignNear: Clue?
    @NSManaged var busStopSign: Clue?
    @NSManaged var rightOfSignFar: Clue?
    @NSManaged var rightOfSignNear: Clue?
    @NSManaged var note: String?
    @NSManaged var viewCount: Int64
    @NSManaged var stop: Stop?

}
