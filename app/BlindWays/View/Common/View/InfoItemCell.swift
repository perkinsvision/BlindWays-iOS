//
//  InfoItemCell.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/18/16.
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

final class InfoItemCell: CardCell {

    var viewModel: InfoItem? {
        didSet {
            iconImageView.tintColor = nil

            if let viewModel = viewModel {
                nameLabel.rz_setTextPronounceable(viewModel.localizedTitle)
                nameLabel.textColor = viewModel.titleColor
                subtitleLabel.text = viewModel.localizedSubtitle
                subtitleLabel.textColor = viewModel.titleColor
                iconImageView.image = viewModel.iconImage
                iconImageView.accessibilityLabel = viewModel.iconLabel
                chevronImageView.isHidden = !viewModel.hasChildren

                if let tintable = viewModel as? TintableItem {
                    iconImageView.tintColor = tintable.iconColor
                }

                if let alertText = viewModel.localizedSupplementalText {
                    subtitleToSupplementalConstraint?.isActive = true
                    supplementalTextLabel.isHidden = false
                    supplementalTextLabel.accessibilityElementsHidden = false
                    supplementalTextLabel.text = alertText.localizedUppercase
                } else {
                    supplementalTextLabel.accessibilityElementsHidden = true
                    subtitleToSupplementalConstraint?.isActive = false
                    supplementalTextLabel.isHidden = true
                }
            }
        }
    }

    fileprivate let nameLabel: UILabel = {
        let label = UILabel("nameLabel")
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()

    fileprivate let subtitleLabel: UILabel = {
        let label = UILabel("subtitleLabel")
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        return label
    }()

    fileprivate let iconImageView: UIImageView = {
        let imageView = UIImageView("iconImageView")
        imageView.image = Asset.icnBus.image
        imageView.tintColor = Colors.Common.windowsBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    fileprivate let supplementalTextLabel: UILabel = {
        let label = UILabel("supplementalTextLabel")
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.backgroundColor = .clear
        label.textColor = Colors.Common.darkGrassGreen
        label.numberOfLines = 0
        return label
    }()

    fileprivate var subtitleToSupplementalConstraint: NSLayoutConstraint?

    // MARK: View

    override func configureView() {
        super.configureView()

        cardView.clipsToBounds = true

        cardView.addSubview(iconImageView)
        cardView.clipsToBounds = true

        cardView.addSubview(iconImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(supplementalTextLabel)
    }

    override func configureStyle() {
        super.configureStyle()

        selectionStyle = .none
        let hasChildren = viewModel?.hasChildren ?? true
        chevronImageView.isHidden = !hasChildren
    }

    override func configureLayout() {
        super.configureLayout()

        let nameTopPadding: CGFloat = 14.0
        let interNamePadding: CGFloat = 6.0
        let subtitleToCardBottomPadding: CGFloat = 14.0
        let subtitleToSupplementalVerticalPadding: CGFloat = 10.0
        let supplementalBottomPadding: CGFloat = 12.0

        let defaultPadding: CGFloat = 2.0

        let leadingTextMargin: CGFloat = 52.0

        let iconCenteringGuide = UILayoutGuide("iconCenteringGuide")
        cardView.addLayoutGuide(iconCenteringGuide)
        iconCenteringGuide.widthAnchor == leadingTextMargin
        iconCenteringGuide.leadingAnchor == cardView.leadingAnchor

        iconImageView.centerXAnchor == iconCenteringGuide.centerXAnchor
        iconImageView.centerYAnchor == iconCenteringGuide.centerYAnchor

        nameLabel.topAnchor == cardView.topAnchor + nameTopPadding
        nameLabel.leadingAnchor == iconCenteringGuide.trailingAnchor
        nameLabel.trailingAnchor == chevronImageView.leadingAnchor - defaultPadding

        subtitleLabel.topAnchor == nameLabel.bottomAnchor + interNamePadding
        subtitleLabel.horizontalAnchors == nameLabel.horizontalAnchors
        // separated to reduce compile time
        let subtitleBottomLayout = cardView.bottomAnchor - subtitleToCardBottomPadding
        subtitleLabel.bottomAnchor == subtitleBottomLayout ~ UILayoutPriorityDefaultLow // break if the supplementary label is visible

        supplementalTextLabel.horizontalAnchors == subtitleLabel.horizontalAnchors
        supplementalTextLabel.bottomAnchor == cardView.bottomAnchor - supplementalBottomPadding

        // separated to reduce compile time
        let supplimentalTextTopLayout = subtitleLabel.bottomAnchor + subtitleToSupplementalVerticalPadding
        subtitleToSupplementalConstraint = (supplementalTextLabel.topAnchor == supplimentalTextTopLayout)

        iconCenteringGuide.topAnchor == nameLabel.topAnchor
        iconCenteringGuide.bottomAnchor == subtitleLabel.bottomAnchor
    }

    // MARK: Accessibility

    internal override var accessibilityLabel: String? {
        get {
            var iconLabel = iconImageView.accessibilityLabel
            if let iconLabelUnwrapped = iconLabel {
                iconLabel = "\(iconLabelUnwrapped); "
            }
            let label: String = iconLabel ?? ""
            let name: String = nameLabel.accessibilityLabel ?? nameLabel.text ?? ""
            let subtitle: String = subtitleLabel.accessibilityLabel ?? ""
            var message = "\(label)\(name); \(subtitle);"
            if !supplementalTextLabel.accessibilityElementsHidden {
                let supplemental: String = supplementalTextLabel.accessibilityLabel ?? supplementalTextLabel.text ?? ""
                message += supplemental
            }

            return message
        }
        set {
            super.accessibilityLabel = newValue
        }
    }

    internal override var accessibilityHint: String? {
        get {
            if let accessibilityHint = viewModel?.accessibilityHint {
                return accessibilityHint
            } else {
                return super.accessibilityHint
            }
        }
        set {
            super.accessibilityHint = newValue
        }
    }

    override var accessibilityCustomActions: [UIAccessibilityCustomAction]? {
        get {
            guard let viewModel = viewModel as? AccessiblyActionableItem else {
                return nil
            }

            guard let accessibilityActions = viewModel.accessibilityActions else {
                return nil
            }

            return accessibilityActions.map {
                UIAccessibilityCustomAction(name: $0.name.string, target: self, selector: $0.selector)
            }
        }
        set {
            super.accessibilityCustomActions = newValue
        }
    }

    // If we have custom accessibility actions, we don't want to also be
    // listed as a button, and tapping us should do nothing
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            if let actions = accessibilityCustomActions, actions.count > 0 {
                return UIAccessibilityTraitNone
            }
            return super.accessibilityTraits
        }
        set {
            super.accessibilityTraits = newValue
        }
    }

}

extension InfoItemCell: LocationInfoActions {

    func getDirectionsTapped() {
        UIApplication.shared.sendAction(#selector(LocationInfoActions.getDirectionsTapped), to: nil, from: self, for: nil)
    }

    func showMapTapped() {
        UIApplication.shared.sendAction(#selector(LocationInfoActions.showMapTapped), to: nil, from: self, for: nil)
    }

}
