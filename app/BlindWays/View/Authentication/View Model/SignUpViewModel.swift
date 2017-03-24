//
//  SignUpViewModel.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 5/26/16.
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

class SignUpViewModel: BaseAuthViewModel, AuthViewModel {

    var localizedTitle: String {
        return UIStrings.signupTitle.string
    }

    var localizedFooterButtonTitle: NSAttributedString? {

        let boldStyle = StringStyle(.font(UIFont.dynamicSize(style: .subheadline, weight: .semibold)))

        let fullStyle = StringStyle(
            .font(UIFont.dynamicSize(style: .subheadline, weight: .regular)),
            .xmlRules([
                .style("bold", boldStyle),
                ])
        )
        return UIStrings.signupAlreadyHaveAccountTitle.string.styled(with: fullStyle)
    }

    var localizedSavingAccessibilityMessage: String {
        return UIStrings.signupAccessibilitySavingMessage.string
    }

    var analyticsName: String {
        return "Join"
    }

    func fields() -> [Any]! {
        var fields = [[String: Any]]()

        fields.append([
            FXFormFieldHeader: UIStrings.signupEmailTitle.string,
            FXFormFieldKey: Constants.emailKey,
            FXFormFieldTitle: "",
            FXFormFieldPlaceholder: UIStrings.signupEmailPlaceholder.string,
            FXFormFieldType: FXFormFieldTypeEmail,
            FXFormFieldCell: FullWidthTextFieldCell.self,
            ])

        fields.append([
            FXFormFieldHeader: UIStrings.signupPasswordTitle.string,
            FXFormFieldKey: Constants.passwordKey,
            FXFormFieldTitle: "",
            FXFormFieldPlaceholder: UIStrings.signupPasswordPlaceholder.string,
            FXFormFieldType: FXFormFieldTypePassword,
            FXFormFieldCell: FullWidthTextFieldCell.self,
            ])

        return fields
    }

    // MARK: Submit

    func submit(completion: @escaping SubmitCompletion) throws {
        if let error = emailValidator.validate(email.rz_trimmed) {
            throw error
        }

        if let error = passwordValidator.validate(password) {
            throw error
        }

        request = client.signUp(email.rz_trimmed, password: password) { (result) in
            self.request = nil
            completion(result.isSuccess, result.error as NSError?)
        }
    }

}
