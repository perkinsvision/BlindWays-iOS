//
//  ClueSetViewModel.swift
//  BlindWays
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

import Foundation
import BonMot

enum ClueDisplayableStyle {

    case navigation
    case review

}

protocol ClueDisplayable {

    var clue: ClueRepresentable? { get }
    var index: Int { get }
    var localizedText: String { get }

    /// Optionally override `localizedText`. Ignored if `nil`.
    var localizedAccessibilityOverride: String? { get }

    var isBusStopSign: Bool { get }
    var confirmed: Bool { get }
    var style: ClueDisplayableStyle { get }

}

struct ClueViewModel: ClueDisplayable {

    let clue: ClueRepresentable?
    let index: Int
    let localizedText: String
    let localizedAccessibilityOverride: String?
    let isBusStopSign: Bool
    let confirmed: Bool
    let style: ClueDisplayableStyle = .navigation

    init(clue: Clue?, index: Int, isBusStopSign: Bool, busStopSignNote: String?) {
        self.clue = clue
        self.index = index
        (self.localizedText, self.localizedAccessibilityOverride) = ClueFormatter(
            clue: clue,
            index: index,
            isBusStopSign: isBusStopSign,
            busStopNote: busStopSignNote).format(.nearToFar)
        self.isBusStopSign = isBusStopSign
        self.confirmed = clue?.confirmed ?? false
    }

}

class ClueSetViewModel {

    enum Orientation {
        case streetOnLeft
        case streetOnRight
    }

    let clueSet: ClueSet
    var orientation: Orientation

    init(clueSet: ClueSet, orientation: Orientation? = nil) {
        self.clueSet = clueSet
        self.orientation = orientation ?? .streetOnLeft
    }

    var localizedClueHeader: NSAttributedString {
        let approachingString: String
        switch self.orientation {
        case .streetOnLeft: approachingString = UIStrings.stopDetailCluesetHeaderApproachingLeft.string
        case .streetOnRight: approachingString = UIStrings.stopDetailCluesetHeaderApproachingRight.string
        }

        let underline = StringStyle(
            .underline(.styleSingle, Colors.Common.windowsBlue),
            .font(.dynamicSize(style: .headline, weight: .heavy))
        )

        let fullStyle = StringStyle(
            .color(Colors.Common.white),
            .font(.dynamicSize(style: .headline, weight: .regular)),
            .lineHeightMultiple(1.2),
            .xmlRules([
                .style("underline", underline),
                ]))

        return approachingString.styled(with: fullStyle)
    }

    var clues: [ClueViewModel] {
        var clueHolders: [ClueHolder] = [
            ClueHolder(clue: clueSet.leftOfSignFar, isBusStopSign: false),
            ClueHolder(clue: clueSet.leftOfSignNear, isBusStopSign: false),
            ClueHolder(clue: clueSet.busStopSign, isBusStopSign: true),
            ClueHolder(clue: clueSet.rightOfSignNear, isBusStopSign: false),
            ClueHolder(clue: clueSet.rightOfSignFar, isBusStopSign: false),
        ]

        if orientation == .streetOnRight {
            clueHolders = clueHolders.reversed()
        }

        var clueViewModels = [ClueViewModel]()

        for index in 0..<clueHolders.count {
            let holder = clueHolders[index]
            let isBusStop = holder.isBusStopSign

            clueViewModels.append(ClueViewModel(
                clue: holder.clue,
                index: index,
                isBusStopSign: isBusStop,
                busStopSignNote: isBusStop ? clueSet.note : nil))
        }

        return clueViewModels
    }

    func clueIndex(fromIndexInTableView indexInTableView: Int) -> Int {
        switch orientation {
        case .streetOnLeft:
            return indexInTableView
        case .streetOnRight:
            let highestClueIndex = clues.count - 1
            return highestClueIndex - indexInTableView
        }
    }

    fileprivate struct ClueHolder {
        let clue: Clue?
        let isBusStopSign: Bool
    }

}
