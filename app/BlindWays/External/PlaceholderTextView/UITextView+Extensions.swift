//
//  UITextView+Extensions.swift
//  BlindWays
//
//  Created by Derek Ostrander on 6/8/16.
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

extension PlaceholderConfigurable where Self: UITextView {

    fileprivate var xConstraint: NSLayoutConstraint? {
        let constraint = constraints
            .filter({ (constraint: NSLayoutConstraint) -> Bool in
                return constraint.firstAttribute == .left &&
                    constraint.secondAttribute == .left &&
                    (constraint.firstItem === self || constraint.secondItem === self)
            })
            .first ?? placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor)
        constraint.isActive = true

        return constraint
    }

    fileprivate var yConstraint: NSLayoutConstraint? {
        let constraint = constraints
            .filter({ (constraint: NSLayoutConstraint) -> Bool in
                return constraint.firstAttribute == .top &&
                    constraint.secondAttribute == .top &&
                    (constraint.firstItem === self || constraint.secondItem === self)
            }).first ?? placeholderLabel.topAnchor.constraint(equalTo: topAnchor)
        constraint.isActive = true

        return constraint
    }

    var placeholderConstraints: OriginConstraints {
        return (xConstraint, yConstraint)
    }

    var placeholderPosition: CGPoint {
        return CGPoint(x: textContainerInset.left + textContainer.lineFragmentPadding, y: textContainerInset.top)
    }

    func adjustPlaceholder() {
        placeholderLabel.isHidden = text.characters.count > 0

        let position = placeholderPosition
        placeholderConstraints.x?.constant = position.x
        placeholderConstraints.y?.constant = position.y
    }

}

extension HeightAutoAdjustable where Self: UITextView {
    fileprivate var bottomOffset: CGPoint {
        let verticalInset = abs(textContainerInset.top - textContainerInset.bottom)
        return CGPoint(x: 0.0,
                       y: contentSize.height - self.bounds.height + verticalInset)
    }

    // Attempts to find the apporpriate constraint and creates one if needed.
    func heightConstraint() -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = constraints
            .filter({ (constraint: NSLayoutConstraint) -> Bool in
                return constraint.firstAttribute == .height &&
                    constraint.firstItem === self &&
                    constraint.isActive &&
                    constraint.multiplier == 1.0
            }).first ?? heightAnchor.constraint(equalToConstant: intrinsicContentHeight)

        if !constraint.isActive {
            constraint.priority = heightPriority
            constraint.isActive = true
            setNeedsLayout()
        }

        return constraint
    }

    var intrinsicContentHeight: CGFloat {
        let height = sizeThatFits(CGSize(width: bounds.height, height: CGFloat.greatestFiniteMagnitude)).height
        guard let font = font else {
            return height
        }

        let minimum = textContainerInset.top + self.textContainerInset.bottom + font.lineHeight
        return max(height, minimum)
    }

    func adjustHeight(animated: Bool) {
        let height = intrinsicContentHeight
        guard height > 0 && heightConstraint().constant != height else { return }
        heightConstraint().constant = height

        setNeedsLayout()

        // this is (most likely) the right view to animate to make for a smooth animation.
        // TODO: Make a delegate callback to get the view to be animating.
        guard let container = superview?.superview, animated else {
            scrollToBottom(animated: animated)
            return
        }

        UIView.animate(withDuration: 0.1, animations: {
            container.layoutIfNeeded()
            if self.bottomOffset.y < (self.font?.lineHeight ?? 0.0) {
                self.scrollToBottom(animated: animated)
            }
        })
    }

    func scrollToBottom(animated: Bool) {
        setContentOffset(bottomOffset, animated: animated)
    }

}
