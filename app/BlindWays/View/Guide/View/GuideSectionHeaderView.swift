//
//  GuideSectionHeaderView.swift
//  BlindWays
//
//  Created by Zev Eisenberg on 8/30/16.
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

import UIKit
import Anchorage
import BonMot

final class GuideSectionHeaderView: UITableViewHeaderFooterView {

    // Public Properties

    var title: UIStrings? {
        didSet {
            titleLabel.attributedText = title?.string.localizedUppercase.styled(
                with:
                .font(.preferredFont(forTextStyle: .callout)),
                .color(Colors.Common.white))
        }
    }

    // Private Properties

    var titleLabel: UILabel = {
        let label = UILabel("titleLabel")
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleLabel)

        titleLabel.horizontalAnchors == contentView.horizontalAnchors + 20.0
        titleLabel.verticalAnchors == contentView.verticalAnchors + 10.0
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

final class GuideSectionAccessibilityOnlyHeaderView: UITableViewHeaderFooterView {

    var title: UIStrings? {
        didSet {
            isAccessibilityElement = (title != nil)
            accessibilityLabel = title?.string
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        let pinnedHeightView = UIView("pinnedHeightView")
        pinnedHeightView.heightAnchor == 1.0 ~ UILayoutPriorityDefaultHigh

        contentView.addSubview(pinnedHeightView)
        pinnedHeightView.edgeAnchors == contentView.edgeAnchors
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
