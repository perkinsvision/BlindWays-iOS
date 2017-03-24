//
//  InfoCardViewController.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 5/9/16.
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
import BonMot

struct InfoCardViewModel {
    let tintColor: UIColor
    /// Each message will be put in a `UILabel` inside a vertical `UIStackView`, from top to bottom
    let messages: [NSAttributedString]
    let image: UIImage
    /// This will be faded to transparent over the image
    let backgroundColor: UIColor
    let actionTitle: String
    let actionSelector: Selector?
}

class InfoCardViewController: CardViewController {

    let viewModel: InfoCardViewModel

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    let gradientView: GradientView = {
        let gradientView = GradientView()
        return gradientView
    }()

    let labelsStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, identifier: "labelsStackView")
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0.0, left: Layout.mediumPadding, bottom: 0.0, right: Layout.mediumPadding)
        stackView.spacing = Layout.mediumPadding
        return stackView
    }()

    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.accessibilityIdentifier = "actionButton"
        button.heightAnchor >= Layout.actionButtonMinHeight
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        return button
    }()

    init(viewModel: InfoCardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    override func loadView() {
        super.loadView()

        view.backgroundColor = viewModel.backgroundColor

        view.addSubview(imageView)
        imageView.addSubview(gradientView)

        view.addSubview(labelsStackView)

        view.addSubview(actionButton)
    }

    func configureView() {
        imageView.image = viewModel.image

        labelsStackView.add(arrangedSubviews: viewModel.messages.map {
            let label = UILabel()
            label.attributedText = $0
            label.numberOfLines = 0
            return label
            })

        let fadeColor = viewModel.backgroundColor.withAlphaComponent(0.0)
        gradientView.colors = (start: fadeColor, end: viewModel.backgroundColor)

        updateActionButtonAppearance(lightBackground: false)

        actionButton.setTitle(viewModel.actionTitle, for: .normal)
        if let action = viewModel.actionSelector {
            actionButton.addTarget(self, action: action, for: .touchUpInside)
        } else {
            actionButton.addTarget(self, action: #selector(InfoCardViewController.handleButtonAction), for: .touchUpInside)
        }
    }

    func configureLayout() {
        imageView.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        imageView.leadingAnchor == view.leadingAnchor
        imageView.trailingAnchor == view.trailingAnchor
        imageView.topAnchor == view.topAnchor
        imageView.heightAnchor == Layout.imageHeight

        gradientView.heightAnchor == Layout.gradientHeight
        gradientView.horizontalAnchors == imageView.horizontalAnchors
        gradientView.bottomAnchor == imageView.bottomAnchor

        labelsStackView.horizontalAnchors == view.horizontalAnchors

        actionButton.centerXAnchor == view.centerXAnchor
        actionButton.topAnchor == labelsStackView.bottomAnchor + Layout.largePadding
        actionButton.bottomAnchor == view.bottomAnchor - Layout.actionButtonInset
        actionButton.horizontalAnchors == view.horizontalAnchors + Layout.actionButtonInset
    }

    ///  Updates the appearance of the action button.
    ///
    ///  - parameter lightBackground: Whether the background of the button should be light.
    func updateActionButtonAppearance(lightBackground: Bool) {
        if lightBackground {
            actionButton.setTitleColor(Colors.Common.darkGrassGreen, for: .normal)
            actionButton.setBackgroundImage(nil, for: .normal)
        } else {
            actionButton.setTitleColor(Colors.Common.white, for: .normal)
            actionButton.setBackgroundImage(Asset.btnGradientRound.image, for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func handleButtonAction() {
        dismiss(animated: true, completion: nil)
    }

}

private extension InfoCardViewController {

    struct Layout {

        static let largePadding = CGFloat(30.0)
        static let mediumPadding = CGFloat(20.0)
        static let imageHeight = CGFloat(310.0)
        static let gradientHeight = CGFloat(128.0)
        static let actionButtonMinHeight = CGFloat(56.0)
        static let actionButtonInset = CGFloat(2.0)

    }

}
