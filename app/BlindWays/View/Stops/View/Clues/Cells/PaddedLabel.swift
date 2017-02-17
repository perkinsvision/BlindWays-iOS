//
//  PaddedLabel.swift
//  BlindWays
//
//  Created by Matthew Buckley on 10/16/16.
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

import Foundation

final class PaddedLabel: UILabel {

    var padding: UIEdgeInsets!

    convenience init(withPadding padding: UIEdgeInsets) {
        self.init(frame: CGRect.zero)
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: padding.top,
                                                left: padding.left,
                                                bottom: padding.bottom,
                                                right: padding.right)

        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }

    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize

        intrinsicSuperViewContentSize.height += padding.top + padding.bottom
        intrinsicSuperViewContentSize.width += padding.left + padding.right

        return intrinsicSuperViewContentSize
    }

}
