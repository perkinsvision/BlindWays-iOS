//
//  SolidColorButton.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 5/11/16.
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

class SolidColorButton: UIButton {

    let highlightAdjustPercent: CGFloat
    let rz_backgroundColor: UIColor
    let rz_titleColor: UIColor

    init(titleColor: UIColor, backgroundColor: UIColor, highlightAdjustPercent: CGFloat = 0.8) {
        self.rz_titleColor = titleColor
        self.rz_backgroundColor = backgroundColor
        self.highlightAdjustPercent = highlightAdjustPercent
        super.init(frame: CGRect.zero)
        self.titleLabel?.textColor = titleColor
        self.backgroundColor = rz_backgroundColor
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.textColor = rz_titleColor
        updateDisabledState()
    }

    override var isHighlighted: Bool {
        willSet(highlighted) {
            if highlighted {
                let adjustedBackgroundColor = rz_backgroundColor.colorByMultiplyingBrightness(by: highlightAdjustPercent)
                let adjustedTitleColor = rz_titleColor.colorByMultiplyingBrightness(by: highlightAdjustPercent)

                let time = DispatchTime.now() + Double(Int64(0.01 * TimeInterval(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time) {
                    self.titleLabel?.textColor = adjustedTitleColor
                    self.backgroundColor = adjustedBackgroundColor
                }
            } else {
                titleLabel?.textColor = rz_titleColor
                backgroundColor = rz_backgroundColor
            }
        }
    }

    override var isEnabled: Bool {
        willSet {
            updateDisabledState()
        }
    }

    fileprivate func updateDisabledState() {
        if isEnabled {
            titleLabel?.textColor = rz_titleColor
        } else {
            titleLabel?.textColor = rz_titleColor.withAlphaComponent(0.5)
        }
    }

}
