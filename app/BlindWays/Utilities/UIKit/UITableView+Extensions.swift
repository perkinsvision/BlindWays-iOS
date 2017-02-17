//
//  UITableView+Extensions.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 4/6/16.
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
import BonMot

extension UITableView {

    func rz_setHeaderText(_ text: String, labelAccessibilityTraits: UIAccessibilityTraits? = nil) {
        // Use #function as the accessibility identifier to make this label easier to find
        // if you encounter it in a debugging session, particularly when using the visual debugger.
        let label = UILabel("label from \(#function)")

        label.attributedText = text.styled(
            with:
            .color(Colors.Common.white),
            .font(.preferredFont(forTextStyle: .subheadline)),
            .numberSpacing(.monospaced),
            .alignment(.center)
        )

        label.backgroundColor = .clear
        label.numberOfLines = 10
        if let traits = labelAccessibilityTraits {
            label.accessibilityTraits = traits
        }
        var labelSize = label.sizeThatFits(CGSize(width: self.bounds.size.width, height: 10000))
        labelSize = CGSize(width: self.bounds.size.width, height: labelSize.height)

        let view = UIView(frame: CGRect(x: 0, y: 0, width: labelSize.width, height: labelSize.height + 10))
        view.backgroundColor = .clear
        label.frame = CGRect(x: 0, y: 0, width: labelSize.width, height: labelSize.height)
        view.addSubview(label)

        tableHeaderView = view
    }

}
