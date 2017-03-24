//
//  ClueFormatter.swift
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

struct ClueFormatter {

    enum Style {

        case nearToFar
        case leftToRight

        fileprivate static let nearToFarClueLabelPrefixes = [
            UIStrings.stopDetailCluesetPrefixBefore.string,
            UIStrings.stopDetailCluesetPrefixCloser.string,
            UIStrings.stopDetailCluesetPrefixBusStopSign.string,
            UIStrings.stopDetailCluesetPrefixBeyond.string,
            UIStrings.stopDetailCluesetPrefixFurtherPast.string,
            ]

        fileprivate static let leftToRightClueLabelPrefixes = [
            UIStrings.stopDetailCluesetReviewPrefixFarLeft.string,
            UIStrings.stopDetailCluesetReviewPrefixNearLeft.string,
            UIStrings.stopDetailCluesetReviewPrefixBusStop.string,
            UIStrings.stopDetailCluesetReviewPrefixNearRight.string,
            UIStrings.stopDetailCluesetReviewPrefixFarRight.string,
            ]

        fileprivate static let nearToFarAccessibilityEmptyClueLabels = [
            UIStrings.stopDetailCluesetAccessibilityEmptyBefore.string,
            UIStrings.stopDetailCluesetAccessibilityEmptyCloser.string,
            UIStrings.stopDetailCluesetAccessibilityEmptyBusStopSign.string,
            UIStrings.stopDetailCluesetAccessibilityEmptyBeyond.string,
            UIStrings.stopDetailCluesetAccessibilityEmptyFurtherPast.string,
            ]

        fileprivate static let leftToRightAccessibilityEmptyReviewLabels = [
            UIStrings.stopDetailCluesetAccessibilityEmptyReviewFarLeft.string,
            UIStrings.stopDetailCluesetAccessibilityEmptyReviewNearLeft.string,
            UIStrings.stopDetailCluesetAccessibilityEmptyReviewBusStop.string,
            UIStrings.stopDetailCluesetAccessibilityEmptyReviewNearRight.string,
            UIStrings.stopDetailCluesetAccessibilityEmptyReviewFarRight.string,
            ]

        var prefixes: [String] {
            switch self {
            case .nearToFar: return Style.nearToFarClueLabelPrefixes
            case .leftToRight: return Style.leftToRightClueLabelPrefixes
            }
        }

        var accessibilityEmptyLabels: [String] {
            switch self {
            case .nearToFar: return Style.nearToFarAccessibilityEmptyClueLabels
            case .leftToRight: return Style.leftToRightAccessibilityEmptyReviewLabels
            }
        }

    }

    let clue: ClueRepresentable?
    let index: Int
    let isBusStopSign: Bool
    let busStopNote: String?

    init(clue: ClueRepresentable?, index: Int, isBusStopSign: Bool, busStopNote: String? = nil) {
        self.clue = clue
        self.index = index
        self.isBusStopSign = isBusStopSign
        self.busStopNote = busStopNote
    }

    func format(_ style: Style) -> (label: String, accessibilityLabel: String?) {
        let prefix = style.prefixes[index]
        var formattedString = ""
        var accessibilityLabel: String? = nil

        if let clue = clue {
            if isBusStopSign {
                formattedString = UIStrings.stopDetailCluesetPlacementInitialFormatBusStopSign(prefix, clue.hint ?? clue.label).string
            } else {
                formattedString = UIStrings.stopDetailCluesetPlacementInitialFormatGeneric(prefix, clue.hint ?? clue.label).string
            }

            if clue.onGrassOrDirt || clue.awayFromCurb {
                if clue.onGrassOrDirt {
                    let signOnGrassString = UIStrings.stopDetailEditCluesetFieldOnGrassTitle.string.localizedLowercase
                    formattedString += UIStrings.stopDetailCluesetPlacementSubsequentFormat(signOnGrassString).string
                }

                if clue.awayFromCurb {
                    let awayFromCurbString: String
                    if Locale.current.isMetric {
                        awayFromCurbString = UIStrings.stopDetailEditCluesetFieldAwayFromCurbMetricTitle.string
                    } else {
                        awayFromCurbString = UIStrings.stopDetailEditCluesetFieldAwayFromCurbImperialTitle.string
                    }
                    formattedString += UIStrings.stopDetailCluesetPlacementSubsequentFormat(awayFromCurbString.localizedLowercase).string
                }
            } else if isBusStopSign {
                let alongCurbString = UIStrings.stopDetailEditCluesetFieldAlongCurbTitle.string.localizedLowercase
                formattedString += UIStrings.stopDetailCluesetPlacementSubsequentFormat(alongCurbString).string
            }

            formattedString = formattedString.rz_trimmed.rz_sentenceTerminated

            if let note = busStopNote, note.characters.count > 0 {
                formattedString += note.rz_trimmed.rz_sentenceTerminated
            }
        } else {
            if isBusStopSign {
                formattedString = UIStrings.stopDetailCluesetPrefixBusStopEmpty.string
            } else {
                formattedString = prefix
            }

            // If there is no clue, override the accessibility label to use a slightly different string
            accessibilityLabel = style.accessibilityEmptyLabels[index]
        }

        return (label: formattedString, accessibilityLabel: accessibilityLabel)
    }

}
