//
//  UIViewController+Alerts.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 4/14/16.
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

extension UIViewController {

    func rz_alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UIStrings.commonDismiss.string, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func rz_alertError(_ error: NSError?, completion: Block? = nil) {
        let title = error?.localizedDescription ?? UIStrings.commonProblem.string
        let message = error?.localizedRecoverySuggestion ?? UIStrings.errorUnknownMessage.string
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UIStrings.commonDismiss.string, style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }

}
