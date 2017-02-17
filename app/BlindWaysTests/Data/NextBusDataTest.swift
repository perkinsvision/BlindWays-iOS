//
//  NextBusDataTest.swift
//  BlindWaysTests
//
//  Created by Nicholas Bonatsakis on 3/30/16.
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
import XCTest
@testable import BlindWays
import Nimble

class NextBusDataTest: XCTestCase {

    func testImport_Good() {
        let data = TestData.fileDataForName("next_bus_predictions", ext: "xml")
        let results = NextBusPrediction.predictionsFromXML(data: data)

        expect(results).notTo(beNil())
        expect(results).to(haveCount(7))

        let prediction = results[0]
        expect(prediction.route).to(equal("93"))
        expect(prediction.destination).to(equal("Sullivan"))
        expect(prediction.arrivalDate).to(equal(Date(timeIntervalSince1970: 1459345200.0)))
        expect(prediction.minutes).to(equal(4))
        expect(prediction.seconds).to(equal(295))

        let prediction5 = results[5]
        expect(prediction5.destination).to(equal("Sullivan via Navy Yard"))
    }

}
