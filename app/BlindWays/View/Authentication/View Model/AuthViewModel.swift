//
//  AuthViewModel.swift
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

import FXForms
import Alamofire
import Swiftilities
import BonMot

typealias SubmitCompletion = (Bool, NSError?) -> Void

@objc
protocol AuthViewModel: FXForm {
    var localizedTitle: String { get }
    var localizedFooterButtonTitle: NSAttributedString? { get }
    var localizedSavingAccessibilityMessage: String { get }
    var analyticsName: String { get }
    func submit(completion: @escaping SubmitCompletion) throws
}

class BaseAuthViewModel: NSObject {

    struct Constants {
        static let emailKey = "email"
        static let passwordKey = "password"
    }

    let client: APIClient
    var request: DataRequest?

    var email: String = ""
    var emailValidator = FieldValidator(fieldName: UIStrings.signupEmailTitle.string, rules: [
        ValidationRule.nonEmpty,
        ValidationRule.validEmail,
        ])

    var password: String = ""
    var passwordValidator = FieldValidator(fieldName: UIStrings.signupPasswordTitle.string, rules: [
        ValidationRule.nonEmpty,
        ValidationRule.minLength(length: 8),
        ])

    init(client: APIClient) {
        self.client = client
    }

    deinit {
        if let request = request {
            request.cancel()
        }
    }

}
