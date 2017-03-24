//
//  AuthCells.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 5/24/16.
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
import FXForms

@objc
protocol FullWidthTextFieldCellActions {
    func doneTapped()
}

/// A text cell that ensures the textField is aligned with the table section header
final class FullWidthTextFieldCell: FXFormTextFieldCell {

    static let minTextFieldWidth: CGFloat = 80
    static let maxTextFieldWidth: CGFloat = 250

    override func setUp() {
        super.setUp()
        textLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        textField.font = UIFont.dynamicSize(style: .headline, weight: .regular)
        textField.textColor = Colors.Common.black
        textField.clearButtonMode = .whileEditing
    }

    override func update() {
        super.update()
        textField.textAlignment = .left

        textLabel?.accessibilityElementsHidden = true
        if let text = textLabel?.text, text.characters.count > 0 {
            textField.accessibilityLabel = text
        } else {
            textField.accessibilityLabel = nil
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var textFieldX: CGFloat = 0.0
        if let textLabel = textLabel {
            if let text = textLabel.text, text.characters.count == 0 {
                // If no label text, make the textField full width
                textFieldX = textLabel.frame.origin.x
            } else {
                // If label text, size the label reasonably and fill the rest of the available space with the textField
                textFieldX = textLabel.frame.maxX
                var labelFrame = textLabel.frame
                let minW = FullWidthTextFieldCell.minTextFieldWidth
                let maxW = FullWidthTextFieldCell.maxTextFieldWidth
                labelFrame.size.width = min(max(textLabel.sizeThatFits(CGSize.zero).width, minW), maxW)
                textLabel.frame = labelFrame
            }
        }

        let rightPadding: CGFloat = 5
        textField.frame = CGRect(x: textFieldX, y: 0, width: contentView.frame.size.width - textFieldX - rightPadding, height: contentView.frame.size.height)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            self.nextCell.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            UIApplication.shared.sendAction(#selector(FullWidthTextFieldCellActions.doneTapped), to: nil, from: self, for: nil)
        }

        return false
    }

}
