//
//  ClueDirectionHeaderView.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 4/18/16.
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

@objc
protocol ClueDirectionHeaderViewActions {
    func changeClueDirection()
}

class ClueDirectionHeaderView: UITableViewHeaderFooterView {

    static let reuseID = "ClueDirectionHeaderView"

    var viewModel: ClueSetViewModel? {
        didSet {
            if let viewModel = viewModel {
                headerLabel.attributedText = viewModel.localizedClueHeader
                let voiceOverString = "\(viewModel.localizedClueHeader.string). \(UIStrings.stopDetailCluesetHeaderAccessibilityChangeButtonHint.string)"
                voiceOverButton.accessibilityLabel = voiceOverString
            }
        }
    }

    var headerLabel: UILabel!
    var changeButton: UIButton!
    var voiceOverButton: UIButton!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureView()
        configureStyle()
        configureLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(ClueDirectionHeaderView.handleVoiceOverStateChange), name: Notification.Name(UIAccessibilityVoiceOverStatusChanged), object: nil)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureView() {
        headerLabel = NoTraitLabel()
        contentView.addSubview(headerLabel)

        changeButton = UIButton(type: .custom)
        changeButton.addTarget(nil, action: #selector(ClueDirectionHeaderViewActions.changeClueDirection), for: .touchUpInside)
        changeButton.setImage(Asset.icnChange.image, for: .normal)
        changeButton.imageView?.contentMode = .center
        contentView.addSubview(changeButton)

        voiceOverButton = UIButton(type: .custom)
        voiceOverButton.addTarget(nil, action: #selector(ClueDirectionHeaderViewActions.changeClueDirection), for: .touchUpInside)
        voiceOverButton.backgroundColor = .clear
        handleVoiceOverStateChange()
        contentView.addSubview(voiceOverButton)
    }

    func configureStyle() {
        headerLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        headerLabel.textColor = Colors.Common.white
        headerLabel.numberOfLines = 30
        headerLabel.isAccessibilityElement = false

        changeButton.isAccessibilityElement = false
    }

    func configureLayout() {
        let buttonVerticalPadding: CGFloat = 10.0
        let headerLeadingPadding: CGFloat = 24.0
        let headerTopPadding: CGFloat = 26.0
        let headerBottomPadding: CGFloat = 21.0
        let buttonWidth: CGFloat = 56.0
        let buttonHorizontalPadding: CGFloat = 10.0

        headerLabel.leadingAnchor == contentView.leadingAnchor + headerLeadingPadding
        headerLabel.topAnchor >= contentView.topAnchor + headerTopPadding
        headerLabel.bottomAnchor <= contentView.bottomAnchor - headerBottomPadding

        changeButton.widthAnchor == buttonWidth

        changeButton.trailingAnchor == contentView.trailingAnchor - buttonHorizontalPadding
        changeButton.centerYAnchor == headerLabel.centerYAnchor
        changeButton.verticalAnchors >= contentView.verticalAnchors + buttonVerticalPadding
        changeButton.leadingAnchor == headerLabel.trailingAnchor + buttonHorizontalPadding

        voiceOverButton.edgeAnchors == contentView.edgeAnchors
    }

    // MARK: Accessibility

    func handleVoiceOverStateChange() {
        voiceOverButton.isUserInteractionEnabled = Accessibility.isVoiceOverRunning()
    }

    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return UIAccessibilityTraitNone
        }
        set (traits) {
            super.accessibilityTraits = traits
        }
    }

    class NoTraitLabel: UILabel {
        override var accessibilityTraits: UIAccessibilityTraits {
            get {
                return UIAccessibilityTraitNone
            }
            set (traits) {
                super.accessibilityTraits = traits
            }
        }
    }

}
