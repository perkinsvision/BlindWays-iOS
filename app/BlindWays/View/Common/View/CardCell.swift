//
//  CardCell.swift
//  BlindWays
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

import Anchorage

class CardCell: UITableViewCell {

    let cardView = UIView("cardView")
    let chevronImageView: UIImageView = {
        let chevronImageView = UIImageView("chevronImageView")
        chevronImageView.image = Asset.icnChevron.image
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.rz_makeHuggingAndResistancePrioritiesRequired()
        return chevronImageView
    }()
    var chevronBottomConstraint: NSLayoutConstraint?
    var highlightedView: UIView!

    // MARK: Init

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureStyle()
        configureLayout()
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            if chevronImageView.isHidden {
                return super.accessibilityTraits
            } else {
                return UIAccessibilityTraitButton | super.accessibilityTraits
            }
        }
        set (traits) {
            super.accessibilityTraits = traits
        }
    }

    func configureView() {
        selectionStyle = .none
        contentView.addSubview(cardView)

        contentView.addSubview(chevronImageView)

        highlightedView = UIView()
        contentView.addSubview(highlightedView)
    }

    func configureStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 3.0

        chevronImageView.isHidden = true

        highlightedView.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        highlightedView.layer.cornerRadius = cardView.layer.cornerRadius
        highlightedView.layer.masksToBounds = true
        highlightedView.isHidden = true
    }

    static let defaultPadding: CGFloat = 2.0

    func configureLayout() {
        cardView.horizontalAnchors == contentView.horizontalAnchors + (CardCell.defaultPadding * 2)
        cardView.verticalAnchors == contentView.verticalAnchors + CardCell.defaultPadding

        chevronImageView.centerYAnchor == cardView.centerYAnchor
        chevronImageView.trailingAnchor == cardView.trailingAnchor - CardCell.defaultPadding

        highlightedView.edgeAnchors == cardView.edgeAnchors
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        highlightedView.isHidden = !highlighted
    }

}
