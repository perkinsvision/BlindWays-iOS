//
//  ReviewCluesViewModel.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 6/21/16.
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

class ReviewCluesViewModel {

    var clues: [ReviewClueViewModel]
    let editClueSetViewModel: EditClueSetViewModel

    init(viewModel: EditClueSetViewModel) {
        self.editClueSetViewModel = viewModel
        self.clues = ReviewCluesViewModel.createReviewClues(viewModel)
    }

    func refreshClues() {
        self.clues = ReviewCluesViewModel.createReviewClues(editClueSetViewModel)
    }

    fileprivate static func createReviewClues(_ viewModel: EditClueSetViewModel) -> [ReviewClueViewModel] {
        var clues = [ReviewClueViewModel]()
        for (index, editClueViewModel) in viewModel.cluesAsList().enumerated() {
            let clue: ClueRepresentable? = editClueViewModel.type != nil ? editClueViewModel : nil
            let isBusStop = editClueViewModel.isBusStopSign

            clues.append(
                ReviewClueViewModel(
                    clue: clue,
                    index: index,
                    isBusStopSign:isBusStop,
                    busStopSignNote: isBusStop ? viewModel.note.value : nil)
            )
        }

        return clues
    }

    // MARK: Table

    enum Section {
        case clues(clues: [ReviewClueViewModel])
        case note(note: EditClueField<String>)

        var numberOfRows: Int {
            switch self {
            case .clues(let clues): return clues.count
            case .note: return 1
            }
        }
    }

    var sections: [Section] {
        return [
            .clues(clues: clues),
            .note(note: editClueSetViewModel.note),
        ]
    }

    func busStopClueIndexPath() -> IndexPath? {
        for (sectionIndex, section) in sections.enumerated() {
            switch section {
            case .clues(let clues):
                for (rowIndex, clue) in clues.enumerated() {
                    if clue.isBusStopSign {
                        return IndexPath(row: rowIndex, section: sectionIndex)
                    }
                }
            default: return nil
            }
        }

        return nil
    }

}

extension EditClueViewModel: ClueRepresentable {
    var label: String {
        if let type = type {
            return ClueType.lookUpClueType(identifier: type, busStop: isBusStopSign)?.label ?? ""
        } else {
            return ""
        }
    }

    var onGrassOrDirt: Bool {
        return onGrassOrDirtField.value ?? false
    }

    var awayFromCurb: Bool {
        return awayFromCurbField.value ?? false
    }

}

struct ReviewClueViewModel: ClueDisplayable {

    let clue: ClueRepresentable?
    let index: Int
    let localizedText: String
    let localizedAccessibilityOverride: String?
    let isBusStopSign: Bool
    let confirmed: Bool = false
    let style: ClueDisplayableStyle = .review

    init(clue: ClueRepresentable?, index: Int, isBusStopSign: Bool, busStopSignNote: String?) {
        self.clue = clue
        self.index = index
        self.isBusStopSign = isBusStopSign
        (self.localizedText, self.localizedAccessibilityOverride) = ClueFormatter(
            clue: clue,
            index: index,
            isBusStopSign: isBusStopSign,
            busStopNote: busStopSignNote).format(.leftToRight)
    }

}
