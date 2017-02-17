//
//  FieldValidator.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 5/25/16.
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

struct FieldValidator {
    let fieldName: String
    let rules: [FieldValidationRule]

    func validate(_ input: String) -> Error? {
        for rule in rules {
            if let error = rule.validate(fieldName: fieldName, input: input) {
                return error
            }
        }

        return nil
    }
}

protocol FieldValidationRule {
    func validate(fieldName: String, input: String) -> Error?
}

enum ValidationRule: FieldValidationRule {
    case nonEmpty
    case minLength(length: Int)
    case validEmail

    func validate(fieldName: String, input: String) -> Error? {
        switch self {
        case .nonEmpty where input.characters.count == 0:
            return errorWith(fieldName: fieldName)
        case .minLength(let length) where input.characters.count < length:
            return errorWith(fieldName: fieldName)
        case .validEmail where !input.isValidEmail:
            return errorWith(fieldName: fieldName)
        default: return nil
        }
    }

}

extension ValidationRule {

    static let domain = "org.perkins.FieldValidationError"

    enum Code: Int {
        case generic
        case nonEmpty
        case minLength
        case validEmail
    }

    var errorCode: Code {
        switch self {
        case .nonEmpty: return .nonEmpty
        case .minLength(_): return .minLength
        case .validEmail: return .validEmail
        }
    }

}

private extension ValidationRule {

    func errorWith(fieldName: String) -> Error {
        switch self {
        case .nonEmpty:
            return error(
                description: localizedString("%@ is required", fieldName.localizedCapitalized),
                recovery: localizedString("Please enter a valid %@.", fieldName.localizedLowercase)
            )
        case .minLength(let length):
            return error(
                description: localizedString("%@ is too short", fieldName.localizedCapitalized),
                recovery: localizedString("%@ must be at least %d characters in length.", fieldName.localizedCapitalized, length)
            )
        case .validEmail:
            return error(
                description: localizedString("%@ is not valid", fieldName.localizedCapitalized),
                recovery: localizedString("Please enter a valid %@.", fieldName.localizedLowercase)
            )
        }
    }

    func error(description: String, recovery: String) -> Error {
        return NSError(domain: ValidationRule.domain, code: errorCode.rawValue, userInfo: [
            NSLocalizedDescriptionKey: description,
            NSLocalizedRecoverySuggestionErrorKey: recovery,
        ])
    }

    func localizedString(_ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, arguments: args)
    }

}

private extension String {

    var isValidEmail: Bool {
        // Source: http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

}
