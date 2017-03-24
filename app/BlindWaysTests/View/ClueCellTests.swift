//
//  ClueCellTests.swift
//  BlindWaysTests
//
//  Created by Zev Eisenberg on 9/19/16.
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

class ClueCellTests: DataTestCase {

    func testClueCellForReviewing() {
        let jsonDict = TestData.jsonDictForFileNamed(DataFilenames.Stops.detail)
        let stop = Stop.rzi_object(from: jsonDict)

        let clueSetViewModel = ClueSetViewModel(clueSet: stop.clueSet!)

        let clueViewModels = clueSetViewModel.clues
        expect(clueViewModels).to(haveCount(5))
        let reviewClueViewModels = clueViewModels.enumerated().map { index, clueViewModel in
            ReviewClueViewModel(
                clue: clueViewModel.clue,
                index: index,
                isBusStopSign: clueViewModel.isBusStopSign,
                busStopSignNote: (clueViewModel.isBusStopSign ? stop.clueSet?.note : nil)
            )
        }
        expect(reviewClueViewModels).to(haveCount(5))

        // Clue 0
        do {
            let reviewClueViewModel = reviewClueViewModels[0]
            let cell = ClueCell(style: .default, reuseIdentifier: "foo")
            cell.viewModel = reviewClueViewModel
            expect(cell.indexLabel.text).to(equal("1"))
            expect(cell.clueTextLabel.text).to(equal("To the far left of the stop, there is a metal pole. "))
            expect(cell.clueTextLabel.accessibilityLabel).to(equal("To the far left of the stop, there is a metal pole. Edit Clue"))
        }

        // Clue 1
        do {
            let reviewClueViewModel = reviewClueViewModels[1]
            let cell = ClueCell(style: .default, reuseIdentifier: "foo")
            cell.viewModel = reviewClueViewModel
            expect(cell.indexLabel.text).to(equal("2"))
            expect(cell.clueTextLabel.text).to(equal("To the near left, there is a mailbox. "))
            expect(cell.clueTextLabel.accessibilityLabel).to(equal("To the near left, there is a mailbox. Edit Clue"))
        }

        // Clue 2
        do {
            let reviewClueViewModel = reviewClueViewModels[2]
            let cell = ClueCell(style: .default, reuseIdentifier: "foo")
            cell.viewModel = reviewClueViewModel
            expect(cell.indexLabel.text).to(equal("3"))
            expect(cell.clueTextLabel.text).to(equal("The bus stop sign is on a building, along the curb. "))
            expect(cell.clueTextLabel.accessibilityLabel).to(equal("The bus stop sign is on a building, along the curb. Edit Clue"))
        }

        // Clue 3
        do {
            let reviewClueViewModel = reviewClueViewModels[3]
            let cell = ClueCell(style: .default, reuseIdentifier: "foo")
            cell.viewModel = reviewClueViewModel
            expect(cell.indexLabel.text).to(equal("4"))
            expect(cell.clueTextLabel.text).to(equal("To the near right of the stop"))
            expect(cell.clueTextLabel.accessibilityLabel).to(equal("No clue to the near right of the stop. Add Clue"))
        }

        // Clue 4
        do {
            let reviewClueViewModel = reviewClueViewModels[4]
            let cell = ClueCell(style: .default, reuseIdentifier: "foo")
            cell.viewModel = reviewClueViewModel
            expect(cell.indexLabel.text).to(equal("5"))
            expect(cell.clueTextLabel.text).to(equal("To the far right, there is a bus shelter. "))
            expect(cell.clueTextLabel.accessibilityLabel).to(equal("To the far right, there is a bus shelter. Edit Clue"))
        }
    }

}
