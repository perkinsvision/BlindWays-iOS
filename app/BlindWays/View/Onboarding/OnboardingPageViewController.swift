//
//  OnboardingPageViewController.swift
//  BlindWays
//
//  Created by Zev Eisenberg on 5/23/16.
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

struct OnboardingPage {

    /// Whether to show this screen. A screen may opt out of being shown if, for example, the permission for which it is asking has already been granted. Defaults to `true`.
    let shouldShow: () -> Bool

    /// The title of the screen. Shows up in the middle, above the primary and secondary action buttons.
    let mainText: UIStrings

    /// The action associated with the primary button
    let primaryAction: (title: UIStrings, action: Block)

    /// Shown below the main button, with an optional prefixed prompt text
    let secondaryAction: (title: UIStrings, action: Block)?

    /// Shown as the right bar button item
    let tertiaryAction: (title: UIStrings, action: Block)?

    /// Vertical spacing between `mainText`, `primaryAction` button, and `secondaryAction` button (if any)
    let verticalSpacing: CGFloat

}

final class OnboardingPageViewController: UIViewController {

    // Private properties

    fileprivate var page: OnboardingPage

    fileprivate var initialAccessibilityFocusView: UIView?

    init(page: OnboardingPage) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "OnboardingPageViewController"

        view.backgroundColor = .clear

        var mutableAccessibilityElements = [UIView]()

        // We can't trust a VC's view's layout margins guide, so make a container view
        let container = UIView("GuideFixingContainerView")
        view.addSubview(container)
        container.edgeAnchors == view.edgeAnchors
        container.layoutMargins = UIEdgeInsets(
            top: 0.0,
            left: Layout.horizontalInsets,
            bottom: page.verticalSpacing,
            right: Layout.horizontalInsets
        )
        container.backgroundColor = .clear

        let mainStackView: UIStackView = {
            let stackView = UIStackView(axis: .vertical, identifier: "mainStackView")
            stackView.spacing = page.verticalSpacing
            stackView.alignment = .center
            return stackView
        }()

        let mainTextLabel: UILabel = {
            let label = UILabel("mainTextLabel")
            label.text = page.mainText.string
            label.textColor = Colors.Common.white
            label.textAlignment = .center
            label.font = Layout.messageFont
            label.numberOfLines = 0
            return label
        }()

        initialAccessibilityFocusView = mainTextLabel

        mutableAccessibilityElements.append(mainTextLabel)

        let primaryActionButton: UIButton = {
            let button = SolidColorButton(titleColor: Colors.Common.marineBlue, backgroundColor: Colors.Common.white)
            button.accessibilityIdentifier = "primaryActionButton"
            button.setTitle(page.primaryAction.title.string, for: .normal)
            button.addTarget(self, action: #selector(OnboardingPageViewController.primaryButtonTapped), for: .touchUpInside)
            button.layer.cornerRadius = Layout.buttonCornerRadius
            button.widthAnchor >= Layout.primaryButtonMinWidth
            button.heightAnchor >= Layout.primaryButtonMinHeight
            button.titleLabel?.font = Layout.mainFont
            return button
        }()

        mutableAccessibilityElements.append(primaryActionButton)

        mainStackView.add(arrangedSubviews: mainTextLabel, primaryActionButton)

        if let secondaryAction = page.secondaryAction {
            let secondaryActionButton: UIButton = {
                let button = UIButton(type: .custom)
                button.accessibilityIdentifier = "secondaryActionButton"
                button.addTarget(self, action: #selector(OnboardingPageViewController.secondaryButtonTapped), for: .touchUpInside)
                button.showsTouchWhenHighlighted = true
                button.heightAnchor == Layout.otherButtonMinHeight
                button.titleLabel?.numberOfLines = 0

                let title = secondaryAction.title.string
                let attributedTitle = title.styled(with: Layout.secondaryActionStyle)
                button.setAttributedTitle(attributedTitle, for: .normal)

                return button
            }()

            mainStackView.addArrangedSubview(secondaryActionButton)

            mutableAccessibilityElements.append(secondaryActionButton)
        }

        if let tertiaryTitle = page.tertiaryAction?.title {
            let tertiaryButton = UIButton(type: .system)
            tertiaryButton.setTitleColor(Colors.Common.white, for: .normal)
            tertiaryButton.titleLabel?.font = Layout.mainFont
            tertiaryButton.setTitle(tertiaryTitle.string, for: .normal)
            tertiaryButton.addTarget(self, action: #selector(OnboardingPageViewController.tertiaryButtonTapped), for: .touchUpInside)
            tertiaryButton.showsTouchWhenHighlighted = true

            container.addSubview(tertiaryButton)
            tertiaryButton.topAnchor == view.topAnchor + Layout.tertiaryButtonPadding.top
            tertiaryButton.trailingAnchor == view.trailingAnchor - Layout.tertiaryButtonPadding.trailing

            mutableAccessibilityElements.append(tertiaryButton)
        }

        view.accessibilityElements = mutableAccessibilityElements

        container.addSubview(mainStackView)
        mainStackView.horizontalAnchors == container.layoutMarginsGuide.horizontalAnchors
        mainStackView.bottomAnchor == container.layoutMarginsGuide.bottomAnchor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Accessibility.shared.screenChanged(focusView: initialAccessibilityFocusView)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

private extension OnboardingPageViewController {

    struct Layout {

        static let tertiaryButtonPadding = (trailing: CGFloat(20.0), top: CGFloat(32.0))
        static let horizontalInsets = CGFloat(30.0)
        static let buttonCornerRadius = CGFloat(4.0)
        static let primaryButtonMinHeight = CGFloat(48.0)
        static let primaryButtonMinWidth = CGFloat(220.0)
        static let otherButtonMinHeight = CGFloat(44.0)
        static let secondaryActionSpacing = CGFloat(9.0)
        static let mainFont = UIFont.dynamicSize(style: .headline, weight: .semibold)
        static let mainFontRegular = UIFont.dynamicSize(style: .headline, weight: .regular)
        static let messageFont = UIFont.dynamicSize(style: .title3, weight: .semibold)

        static let secondaryActionStyle = whiteStyle.byAdding(
            .font(mainFontRegular),
            .xmlRules([
                .style("bold", whiteStyle.byAdding(.font(mainFont))),
                ]))

        fileprivate static let whiteStyle = StringStyle(.color(Colors.Common.white))

    }

    @objc func primaryButtonTapped() {
        // Prevents screen reader from rereading action button after it is tapped,
        // because we are always moving on to the next screen after that.
        view.accessibilityElements = []
        page.primaryAction.action()
    }

    @objc func secondaryButtonTapped() {
        page.secondaryAction?.action()
    }

    @objc func tertiaryButtonTapped() {
        page.tertiaryAction?.action()
    }

}
