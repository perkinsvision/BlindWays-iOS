//
//  ClueSetViewModelTests.swift
//  BlindWaysTests
//
//  Created by Nicholas Bonatsakis on 4/13/16.
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

class ClueSetViewModelTests: DataTestCase {

    func testCluesList() {
        let jsonDict = TestData.jsonDictForFileNamed(DataFilenames.Stops.detail)
        let stop = Stop.rzi_object(from: jsonDict)

        let viewModel = ClueSetViewModel(clueSet: stop.clueSet!)
        expect(viewModel).notTo(beNil())

        var clues = viewModel.clues
        expect(clues).to(haveCount(5))

        expect(clues[0].clue).notTo(beNil())
        expect(clues[0].index).to(equal(0))
        expect(clues[0].isBusStopSign).to(beFalse())
        expect(clues[0].localizedText).to(equal("Before the stop, there is a metal pole. "))
        expect(clues[0].localizedAccessibilityOverride).to(beNil())

        expect(clues[1].clue).notTo(beNil())
        expect(clues[1].index).to(equal(1))
        expect(clues[1].isBusStopSign).to(beFalse())
        expect(clues[1].localizedText).to(equal("Closer to the stop, there is a mailbox. "))
        expect(clues[1].localizedAccessibilityOverride).to(beNil())

        expect(clues[2].clue).notTo(beNil())
        expect(clues[2].index).to(equal(2))
        expect(clues[2].isBusStopSign).to(beTrue())
        expect(clues[2].localizedText).to(equal("The bus stop sign is on a building, along the curb. "))
        expect(clues[2].localizedAccessibilityOverride).to(beNil())

        expect(clues[3].clue).to(beNil())
        expect(clues[3].index).to(equal(3))
        expect(clues[3].isBusStopSign).to(beFalse())
        expect(clues[3].localizedText).to(equal("Beyond the stop"))
        expect(clues[3].localizedAccessibilityOverride).to(equal("No clue beyond the stop"))

        expect(clues[4].clue).toNot(beNil())
        expect(clues[4].index).to(equal(4))
        expect(clues[4].isBusStopSign).to(beFalse())
        expect(clues[4].localizedText).to(equal("Further past the stop, there is a bus shelter. "))
        expect(clues[4].localizedAccessibilityOverride).to(beNil())

        viewModel.orientation = .streetOnRight
        clues = viewModel.clues

        expect(clues[0].clue).toNot(beNil())
        expect(clues[0].index).to(equal(0))
        expect(clues[0].isBusStopSign).to(beFalse())
        expect(clues[0].localizedText).to(equal("Before the stop, there is a bus shelter. "))
        expect(clues[0].localizedAccessibilityOverride).to(beNil())
    }

}
