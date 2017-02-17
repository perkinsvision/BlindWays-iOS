//
//  GuideViewModel.swift
//  BlindWays
//
//  Created by Zev Eisenberg on 8/29/16.
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

struct GuideViewModel {

    struct Section {

        let title: UIStrings
        let items: [Item]

    }

    enum Item {

        case guide(message: UIStrings)
        case example(message: UIStrings, accessibilityPrefix: UIStrings, color: UIColor, icon: Asset)

    }

    let sections: [Section] = [
        Section(
            title: .guideSectionHints,
            items: [
                .guide(message: .guideMessageFixtures),
                .guide(
                    message: Locale.current.isMetric ? .guideMessageLandmarksMetric : .guideMessageLandmarksImperial),
                .guide(message: .guideMessageFeatures),
                .guide(message: .guideMessageCasual),
                .guide(message: .guideMessageVisual),
            ]),
        Section(title: .guideSectionExamples, items: [
            .example(
                message: .guideExampleGood,
                accessibilityPrefix: .guideExampleAccessibilityPrefixHelpful(UIStrings.guideExampleGood.string),
                color: Colors.Common.darkGrassGreen,
                icon: .icnExampleDo),
            .example(
                message: .guideExampleBad,
                accessibilityPrefix: .guideExampleAccessibilityPrefixUnhelpful(UIStrings.guideExampleBad.string),
                color: Colors.Common.darkOrange,
                icon: .icnExampleDont),
            ]),
    ]

    subscript(indexPath: IndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.item]
    }

}
