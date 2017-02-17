//
//  TintedButton.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 4/13/16.
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
import UIKit

/// A button that looks and behaves like the default "Get" button in iTunes
class TintedButton: UIButton {

    let rz_backgroundColor: UIColor
    let rz_tintColor: UIColor

    init(backgroundColor: UIColor, tintColor: UIColor) {
        self.rz_backgroundColor = backgroundColor
        self.rz_tintColor = tintColor

        super.init(frame: CGRect.zero)

        self.backgroundColor = backgroundColor
        self.setTitleColor(tintColor, for: .normal)

        self.layer.borderColor = self.rz_tintColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4.0
        self.layer.contentsScale = UIScreen.main.scale
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        willSet(highlighted) {
            if highlighted {
                setTitleColor(rz_backgroundColor, for: .normal)
                backgroundColor = rz_tintColor
            } else {
                setTitleColor(rz_tintColor, for: .normal)
                backgroundColor = rz_backgroundColor
            }
        }
    }

}
