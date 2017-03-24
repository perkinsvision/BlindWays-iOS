//
//  GuideMessageCell.swift
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

final class GuideMessageCell: UITableViewCell {

    // Public Properties

    var message: UIStrings? {
        didSet {
            messageLabel.attributedText = message?.string.styled(
                with:
                .font(UIFont.dynamicSize(style: .body, weight: .semibold)),
                .color(Colors.Common.white)
            )
        }
    }

    var hairlineVisible: Bool = true {
        didSet {
            hairline.isHidden = !hairlineVisible
        }
    }

    // Private Properties

    fileprivate let messageLabel: UILabel = {
        let label = UILabel("messageLabel")
        label.numberOfLines = 0
        return label
    }()

    fileprivate let hairline = HairlineView(axis: .horizontal, thickness: 1.0, color: Colors.Common.marineBlue)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        let wrapperView = UIView("wrapperView")
        contentView.addSubview(wrapperView)

        wrapperView.addSubview(messageLabel)
        wrapperView.addSubview(hairline)

        wrapperView.layoutMargins = UIEdgeInsets(top: 23.0, left: 20.0, bottom: 23.0, right: 20.0)

        wrapperView.edgeAnchors == contentView.edgeAnchors

        messageLabel.edgeAnchors == wrapperView.layoutMarginsGuide.edgeAnchors

        hairline.horizontalAnchors == wrapperView.layoutMarginsGuide.horizontalAnchors
        hairline.bottomAnchor == wrapperView.bottomAnchor
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
