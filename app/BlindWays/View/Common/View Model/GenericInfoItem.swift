//
//  GenericInfoItem.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 4/4/16.
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

protocol InfoItem {

    var localizedTitle: String { get }
    var localizedSubtitle: String? { get }
    var localizedSupplementalText: String? { get }
    var hasChildren: Bool { get }
    var titleColor: UIColor { get }
    var iconImage: UIImage { get }
    var iconLabel: String? { get }

    var accessibilityHint: String? { get }

}

protocol TintableItem {

    var iconColor: UIColor { get }

}

protocol AccessiblyActionableItem {

    var accessibilityActions: [(name: UIStrings, selector: Selector)]? { get }

}

extension InfoItem {

    var hasChildren: Bool {
        return false
    }

    var titleColor: UIColor {
        return Colors.Common.black
    }

}
