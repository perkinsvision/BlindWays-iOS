//
//  EmptyState.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/23/16.
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

typealias EmptyStateAction = () -> Void
typealias EmptyStateAnimation = () -> Void

struct EmptyStateStyle {

    enum Layout {

        case imageCenter
        case imageBottom

    }

    let backgroundColor: UIColor
    let imageTintColor: UIColor
    let messageTintColor: UIColor
    let messageFont: UIFont
    let actionTintColor: UIColor
    let actionFont: UIFont
    var layout: Layout

    init(backgroundColor: UIColor,
         imageTintColor: UIColor,
         messageTintColor: UIColor,
         messageFont: UIFont,
         actionTintColor: UIColor,
         actionFont: UIFont,
         layout: Layout  = .imageCenter) {

        self.backgroundColor = backgroundColor
        self.imageTintColor = imageTintColor
        self.messageTintColor = messageTintColor
        self.messageFont = messageFont
        self.actionTintColor = actionTintColor
        self.actionFont = actionFont
        self.layout = layout
    }

}

protocol EmptyState {

    var style: EmptyStateStyle? { get }
    var message: String { get }
    var image: UIImage? { get }
    var actionTitle: String? { get }
    var action: Selector? { get }

}

extension UIViewController {

    func rzv_showEmptyState(_ emptyState: EmptyState, centerOffset: CGPoint = CGPoint.zero, animationBlock: EmptyStateAnimation? = nil) {
        if activeEmptyState != nil {
            self.rzv_hideEmptyState()
        }

        self.activeEmptyState?.removeFromParentViewController()
        let emptyStateVC = EmptyStateViewController(emptyState: emptyState)
        emptyStateVC.view.alpha = 0.0
        self.rz_addChildViewController(emptyStateVC, inView: self.view, layoutBlock: { (view) in
            view.leadingAnchor == self.view.leadingAnchor
            view.trailingAnchor == self.view.trailingAnchor
            view.centerXAnchor == self.view.centerXAnchor + centerOffset.x
            view.centerYAnchor == self.view.centerYAnchor + centerOffset.y
        })

        UIView.animate(withDuration: 0.2, animations: {
            emptyStateVC.view.alpha = 1.0
            animationBlock?()
        })
    }

    func rzv_hideEmptyState(_ animationBlock: EmptyStateAnimation? = nil) {
        if let existingViewController = activeEmptyState {
            UIView.animate(withDuration: 0.2, animations: {
                existingViewController.view.alpha = 0.0
                animationBlock?()
            }, completion: { _ in
                self.rz_removeChildViewController(existingViewController)
            })
        }
    }

    // MARK: Helper

    var activeEmptyState: EmptyStateViewController? {
        for viewController in self.childViewControllers {
            if let viewController = viewController as? EmptyStateViewController {
                return viewController
            }
        }

        return nil
    }

}

class EmptyStateViewController: UIViewController {

    static let defaultStyle = EmptyStateStyle(backgroundColor: .clear,
                                              imageTintColor: .lightGray,
                                              messageTintColor: .lightGray,
                                              messageFont: UIFont.systemFont(ofSize: 17),
                                              actionTintColor: .blue,
                                              actionFont: UIFont.boldSystemFont(ofSize: 19))

    let emptyState: EmptyState

    // MARK: Init

    init(emptyState: EmptyState) {
        self.emptyState = emptyState
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    override func loadView () {
        view = EmptyStateView(emptyState: emptyState)
    }

}

class EmptyStateView: UIView {

    let emptyState: EmptyState
    let style: EmptyStateStyle

    var label: UILabel?
    var imageView: UIImageView?
    var button: UIButton?

    init(emptyState: EmptyState) {
        self.emptyState = emptyState
        self.style = emptyState.style ?? EmptyStateViewController.defaultStyle
        super.init(frame: CGRect.zero)
        configureView()
        configureLayout()
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static let maxButtonWidth: CGFloat = 222.0

}

private extension EmptyStateView {

    func configureView() {
        self.backgroundColor = style.backgroundColor

        let messageLabel = UILabel()
        messageLabel.font = style.messageFont
        messageLabel.textColor = style.messageTintColor
        messageLabel.numberOfLines = 50
        messageLabel.textAlignment = .center
        messageLabel.text = emptyState.message
        messageLabel.widthAnchor == 280
        self.label = messageLabel

        if let actionTitle = emptyState.actionTitle, let action = emptyState.action {
            let actionButton = SolidColorButton(titleColor: Colors.Common.black, backgroundColor: Colors.Common.white)
            actionButton.titleLabel?.font = style.actionFont
            actionButton.setTitle(actionTitle, for: .normal)
            actionButton.layer.cornerRadius = 4.0
            actionButton.layer.masksToBounds = true

            actionButton.addTarget(nil, action: action, for: .touchUpInside)

            actionButton.widthAnchor == EmptyStateView.maxButtonWidth
            actionButton.heightAnchor == 44

            self.button = actionButton
        }

        if let image = emptyState.image {
            let imageView = UIImageView(image: image)
            imageView.tintColor = style.imageTintColor

            if style.layout == .imageBottom {
                imageView.contentMode = .scaleAspectFit
                let heightConstraint = NSLayoutConstraint(item: imageView,
                                                          attribute: .height,
                                                          relatedBy: .lessThanOrEqual,
                                                          toItem: imageView,
                                                          attribute: .width,
                                                          multiplier: image.size.height / image.size.width,
                                                          constant: 0.0)
                imageView.addConstraint(heightConstraint)
            } else {
                imageView.contentMode = .center
            }

            self.imageView = imageView
        }
    }

    func configureLayout() {
        switch emptyState.style!.layout {
        case .imageCenter: layoutImageCenter()
        case .imageBottom: layoutImageBottom()
        }
    }

    func layoutImageCenter() {
        let stackView = UIStackView()
        addSubview(stackView)
        stackView.edgeAnchors == self.edgeAnchors

        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.alignment = .center

        if let imageView = imageView {
            stackView.addArrangedSubview(imageView)
        }

        if let label = label {
            if stackView.arrangedSubviews.count > 0 {
                let softSpacer = UIView()
                softSpacer.heightAnchor == 40 ~ UILayoutPriorityDefaultLow
                softSpacer.heightAnchor >= 10
                stackView.addArrangedSubview(softSpacer)
            }
            stackView.addArrangedSubview(label)
        }

        if let button = button {
            if stackView.arrangedSubviews.count > 0 {
                let softSpacer = UIView()
                softSpacer.heightAnchor == 40 ~ UILayoutPriorityDefaultLow
                softSpacer.heightAnchor >= 10
                stackView.addArrangedSubview(softSpacer)
            }
            stackView.addArrangedSubview(button)
        }
    }

    func layoutImageBottom() {
        guard let label = label, let button = button else {
            layoutImageCenter()
            return
        }

        if let imageView = imageView {
            addSubview(imageView)
            imageView.leadingAnchor == self.leadingAnchor
            imageView.trailingAnchor == self.trailingAnchor
            imageView.bottomAnchor == self.bottomAnchor
        }

        let buttonHolder = UIView(frame: CGRect.zero)
        buttonHolder.translatesAutoresizingMaskIntoConstraints = false
        buttonHolder.addSubview(button)
        buttonHolder.widthAnchor == EmptyStateView.maxButtonWidth + 20
        button.centerXAnchor == buttonHolder.centerXAnchor
        button.centerYAnchor == buttonHolder.centerYAnchor

        // A UIStackView would make a lot of sense here, but it caused
        // problems on iOS 10 where the _UITableViewHeaderFooterContentView
        // containing this view would sometimes shift to the left by 47.5 pt.

        addSubview(label)
        addSubview(buttonHolder)

        label.heightAnchor == buttonHolder.heightAnchor

        label.centerXAnchor == centerXAnchor
        buttonHolder.centerXAnchor == centerXAnchor

        label.topAnchor == topAnchor
        label.bottomAnchor == buttonHolder.topAnchor

        if let imageView = imageView {
            buttonHolder.bottomAnchor == imageView.topAnchor
        } else {
            buttonHolder.bottomAnchor == bottomAnchor
        }
    }

}
