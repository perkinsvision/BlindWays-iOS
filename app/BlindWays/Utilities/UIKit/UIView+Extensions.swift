//
//  UIView+Extensions.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/21/16.
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
import Swiftilities

// MARK: - Utility

extension UIView {

    convenience init(_ accessibilityIdentifier: String) {
        self.init(frame: .zero)
        self.accessibilityIdentifier = accessibilityIdentifier
    }

    func rz_makeHuggingAndResistancePrioritiesRequired() {
        setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
    }

}

// MARK: Activity

protocol ActivityIndicator {

    func present(in view: UIView, animated: Bool, adjustPositionForKeyboard: Bool, animationBlock: Block?)
    func hide(animated: Bool, animationBlock: Block?, completion: (() -> Void)?)

    func startAnimating()
    func stopAnimating()

}

private final class ActivityIndicatorWrapperView: UIView { }

extension ActivityIndicator where Self: UIView {

    func present(in view: UIView, animated: Bool = true, adjustPositionForKeyboard: Bool = false, animationBlock: Block? = nil) {

        let wrapper = ActivityIndicatorWrapperView()
        wrapper.addSubview(self)
        view.addSubview(wrapper)

        centerXAnchor == wrapper.centerXAnchor
        centerYAnchor == wrapper.centerYAnchor

        wrapper.topAnchor == view.topAnchor

        // !!! Can't pin to leading and trailing, because if view is
        // a scroll view, that may not work correctly, so use leading and width instead.
        wrapper.leadingAnchor == view.leadingAnchor
        wrapper.widthAnchor == view.widthAnchor

        let pinWrapperHeight: Block = { wrapper.heightAnchor == view.heightAnchor }

        if adjustPositionForKeyboard {
            if let keyboardGuide = view.keyboardLayoutGuide {
                wrapper.bottomAnchor == keyboardGuide.topAnchor
            } else {
                Log.warn("Attempting to present alert with keyboard avoidance, but there is no keyboard layout guide. You must add a keyboard layout guide some time before presenting the keyboard, becuase it gets updated only when the keyboard frame changes.")
                pinWrapperHeight()
            }
        } else {
            pinWrapperHeight()
        }

        if animated {
            alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 1.0
                animationBlock?()
            })
        }

        startAnimating()
    }

    func hide(animated: Bool = true, animationBlock: Block? = nil, completion: (() -> Void)? = nil) {
        if animated {
            let alpha = self.alpha
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0.0
                animationBlock?()
                }, completion: { _ in
                    if let superview = self.superview, superview is ActivityIndicatorWrapperView {
                        superview.removeFromSuperview()
                    }
                    self.removeFromSuperview()
                    self.alpha = alpha
                    self.stopAnimating()

                    completion?()
            })
        } else {
            if let superview = self.superview, superview is ActivityIndicatorWrapperView {
                superview.removeFromSuperview()
            }
            removeFromSuperview()
            stopAnimating()
        }
    }

}

extension UIActivityIndicatorView: ActivityIndicator {}
