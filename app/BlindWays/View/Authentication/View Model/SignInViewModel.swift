//
//  SignInViewModel.swift
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

class SignInViewModel: BaseAuthViewModel, AuthViewModel {

    var localizedTitle: String {
        return UIStrings.signinTitle.string
    }

    var localizedFooterButtonTitle: NSAttributedString? {
        let font = UIFont.dynamicSize(style: .subheadline, weight: .semibold)
        return UIStrings.signinForgotPasswordButtonTitle.string.styled(with: .font(font))
    }

    var localizedSavingAccessibilityMessage: String {
        return UIStrings.signinAccessibilitySavingMessage.string
    }

    var analyticsName: String {
        return "SignIn"
    }

    func fields() -> [Any]! {
        var fields = [[String: Any]]()

        fields.append([
            FXFormFieldHeader: UIStrings.signinHeader.string,
            FXFormFieldKey: Constants.emailKey,
            FXFormFieldTitle: UIStrings.signinEmailTitle.string,
            FXFormFieldPlaceholder: UIStrings.signinEmailPlaceholder.string,
            FXFormFieldType: FXFormFieldTypeEmail,
            FXFormFieldCell: FullWidthTextFieldCell.self,
            ])

        fields.append([
            FXFormFieldKey: Constants.passwordKey,
            FXFormFieldTitle: UIStrings.signinPasswordTitle.string,
            FXFormFieldPlaceholder: UIStrings.signinPasswordPlaceholder.string,
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

        request = client.signIn(email.rz_trimmed, password: password) { (result) in
            self.request = nil
            completion(result.isSuccess, result.error as NSError?)
        }
    }

    func forgotPassword(_ email: String, completion: @escaping SubmitCompletion) throws {
        if let error = emailValidator.validate(email.rz_trimmed) {
            throw error
        }

        request = client.resetPassword(email.rz_trimmed) { (result) in
            self.request = nil
            completion(result.isSuccess, result.error as NSError?)
        }
    }

}
