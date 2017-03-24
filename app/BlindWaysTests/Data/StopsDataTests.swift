//
//  StopsDataTests.swift
//  BlindWaysTests
//
//  Created by Nicholas Bonatsakis on 3/16/16.
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
import Nimble
import CoreLocation

class StopsDataTests: DataTestCase {

    func testImportStops() {
        let jsonArray = TestData.jsonArrayForFileNamed(DataFilenames.Stops.search)
        let stops = Stop.rzi_objects(from: jsonArray) as! [Stop]
        saveContext()

        expect(stops).notTo(beNil())
        expect(stops).to(haveCount(3))

        let stop = stops.filter { $0.remoteID == 5752 }.first!
        expect(stop.remoteID).to(equal(5752))
        expect(stop.name).to(equal("Devonshire St @ Milk St"))
        print("stop description is: \(stop.desc)")
        expect(stop.desc).to(beNil())
        expect(stop.routes!.count).to(equal(2))
        expect(stop.gtfsID).to(equal("6548"))
        expect(stop.needsMoreClues).to(beFalsy())
        expect(stop.location.coordinate.latitude).to(beCloseTo(42.3568))
        expect(stop.location.coordinate.longitude).to(beCloseTo(-71.0574))
    }

    func testImportStop() {
        let jsonDict = TestData.jsonDictForFileNamed(DataFilenames.Stops.detail)
        let stop = Stop.rzi_object(from: jsonDict)
        saveContext()

        expect(stop).notTo(beNil())
        expect(stop.clueSet).notTo(beNil())

        let clueSet = stop.clueSet!
        expect(clueSet.createdTimestamp).notTo(beNil())
        expect(clueSet.lastModifiedTimestamp).notTo(beNil())
        expect(clueSet.viewCount).to(equal(4))

        expect(clueSet.leftOfSignFar).notTo(beNil())
        expect(clueSet.leftOfSignNear).notTo(beNil())
        expect(clueSet.busStopSign).notTo(beNil())
        expect(clueSet.rightOfSignNear).to(beNil())
        expect(clueSet.rightOfSignFar).notTo(beNil())

        let sign = clueSet.busStopSign!
        expect(sign.remoteID).to(equal(871))
        expect(sign.type).to(equal("BUS_SIGN_BUILDING"))
        expect(sign.label).to(equal("on a building"))
        expect(sign.confirmed).to(beFalsy())
    }

}
