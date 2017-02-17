//
//  SettingsCells.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 6/7/16.
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
import FXForms

struct SettingsCellKeypaths {

    static let textColor = "textLabel.textColor"

    static let accessoryType = "accessoryType"

}

class SettingsEditableValueCell: FXFormDefaultCell {

    override func setUp() {
        super.setUp()
        textLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        textLabel?.textColor = Colors.Common.black
        detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        detailTextLabel?.textColor = Colors.Common.darkGrassGreen
    }

}

class SettingsButtonCell: FXFormDefaultCell {

    override func setUp() {
        super.setUp()
        textLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        textLabel?.textColor = Colors.Common.black
        detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
    }

    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return UIAccessibilityTraitButton
        }
        set {
            super.accessibilityTraits = newValue
        }
    }

}

class SettingsLinkCell: FXFormDefaultCell {

    override func setUp() {
        super.setUp()
        textLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        textLabel?.textColor = Colors.Common.black
        detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
    }

    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return UIAccessibilityTraitLink
        }
        set {
            super.accessibilityTraits = newValue
        }
    }

}

/// Default cell deselects immediately on selection. We don't want this
/// because we want to control deselection with Swiftilities's smoothlyDeselectItems,
/// so we override didSelect(with:controller:) and don't call super.
class SettingsNavigationCell: SettingsButtonCell {

    override func didSelect(with tableView: UITableView!, controller: UIViewController!) {
        // cause any subviews of the table view to resign first responder, if applicable.
        tableView.endEditing(true)
        self.field.action(self)
    }

}
