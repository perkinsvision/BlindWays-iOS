//
//  HairlineView.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 6/24/16.
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

final class HairlineView: UIView {

    var axis: UILayoutConstraintAxis {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsUpdateConstraints()
        }
    }

    var thickness: CGFloat {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsUpdateConstraints()
        }
    }

    fileprivate var thicknessConstraint: NSLayoutConstraint?

    init(axis: UILayoutConstraintAxis, thickness: CGFloat = CGFloat(1.0 / UIScreen.main.scale), color: UIColor? = UIColor(white: 0.0, alpha: 0.3)) {
        self.axis = axis
        self.thickness = thickness
        super.init(frame: .zero)
        self.backgroundColor = color
        self.accessibilityIdentifier = "hairline"
        setNeedsUpdateConstraints()
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        thicknessConstraint?.isActive = false
        thicknessConstraint = ((axis == .horizontal ? heightAnchor : widthAnchor) == thickness)
        super.updateConstraints()
    }

    override var intrinsicContentSize: CGSize {
        var size = CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)
        switch axis {
        case .horizontal:
            size.height = thickness
        case .vertical:
            size.width = thickness
        }
        return size
    }

    override func contentHuggingPriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority {
        return (self.axis == axis ? UILayoutPriorityRequired : UILayoutPriorityDefaultLow)
    }

    override func contentCompressionResistancePriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority {
        return contentHuggingPriority(for: axis)
    }

}
