//
//  GuideExampleCell.swift
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

final class GuideExampleCell: UITableViewCell {

    // Public Properties

    // swiftlint:disable large_tuple
    var configuration: (message: UIStrings, accessibilityPrefix: UIStrings, color: UIColor, icon: Asset)? {
        didSet {
            guard let configuration = configuration else {
                messageLabel.attributedText = nil
                iconView.image = nil
                accessibilityLabel = nil
                return
            }

            messageLabel.attributedText = configuration.message.string.styled(
                with:
                .font(UIFont.dynamicSize(style: .body, weight: .semibold)),
                .color(configuration.color))
            accessibilityLabel = configuration.accessibilityPrefix.string

            iconView.image = configuration.icon.image
        }
    }
    // swiftlint:enable large_tuple

    // Private Properties

    fileprivate let messageLabel: UILabel = {
        let label = UILabel("messageLabel")
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        return label
    }()

    fileprivate let iconView: UIImageView = {
        let imageView = UIImageView("imageView")
        imageView.contentMode = .scaleAspectFit
        imageView.rz_makeHuggingAndResistancePrioritiesRequired()
        return imageView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        let cardView = UIView("cardView")
        cardView.layer.cornerRadius = 2.0
        cardView.backgroundColor = Colors.Common.white

        let stackView = UIStackView(
            axis: .horizontal,
            identifier: nil,
            arrangedSubviews: [
                messageLabel,
                iconView,
            ]
        )
        stackView.spacing = 12.0
        stackView.distribution = .fill
        stackView.alignment = .center

        cardView.layoutMargins = UIEdgeInsets(top: 14.0, left: 16.0, bottom: 14.0, right: 16.0)

        contentView.addSubview(cardView)
        cardView.addSubview(stackView)

        cardView.horizontalAnchors == contentView.horizontalAnchors + 4.0
        cardView.verticalAnchors == contentView.verticalAnchors + 2.0

        stackView.edgeAnchors == cardView.layoutMarginsGuide.edgeAnchors
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
