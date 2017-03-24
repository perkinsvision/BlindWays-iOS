//
//  UIStackView+Extensions.swift
//  BlindWays
//
//  Created by Zev Eisenberg on 5/24/16.
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

extension UIStackView {

    convenience init(axis: UILayoutConstraintAxis, identifier: String? = nil, arrangedSubviews: UIView...) {
        self.init(axis: axis, identifier: identifier, arrangedSubviews: arrangedSubviews)
    }

    convenience init(axis: UILayoutConstraintAxis) {
        self.init()
        self.axis = axis
    }

    convenience init(axis: UILayoutConstraintAxis, identifier: String? = nil, arrangedSubviews: [UIView]) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.accessibilityIdentifier = identifier
    }

    func add(arrangedSubviews: [UIView]) {
        arrangedSubviews.forEach(addArrangedSubview)
    }

    func add(arrangedSubviews: UIView...) {
        add(arrangedSubviews: arrangedSubviews)
    }

}
