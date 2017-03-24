//
//  ServiceError.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/8/16.
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

enum ServiceError {

    static let Domain = AppDelegate.reverseDomain("service")

    enum Code: Int {

        case invalidResponseContent = -7001
        case invalidChangePassword = -7002
        case jsonSerializationFailed = -7003
        case serverGeneratedError = -7004
        case unknown = -7999

        var userInfo: [String: Any] {
            switch self {
            case .invalidChangePassword:
                return [
                    NSLocalizedDescriptionKey: UIStrings.settingsChangePasswordAlertFailureTitle.string,
                    NSLocalizedRecoverySuggestionErrorKey: UIStrings.settingsChangePasswordAlertFailureMessage.string,
                ]
            default:
                return [
                    NSLocalizedDescriptionKey: UIStrings.commonProblem.string,
                ]
            }
        }

    }

    fileprivate enum ServerError: String {

        case EmailAddressAlreadyInUse = "EMAIL_ADDRESS_ALREADY_IN_USE"
        case InvalidCredentials = "INVALID_CREDENTIALS"

        var localizedString: String {
            switch self {
            case .EmailAddressAlreadyInUse:
                return UIStrings.errorEmailAlreadyInUse.string
            case .InvalidCredentials:
                return UIStrings.errorInvalidCredentials.string
            }
        }

    }

    static func error(with code: Code) -> NSError {
        return NSError(domain: Domain, code: code.rawValue, userInfo: code.userInfo)
    }

    static func serverError(reason: String, serverReadableFallback: String?) -> NSError {
        if let localizedString = ServerError(rawValue: reason)?.localizedString {
            return NSError(domain: Domain, code: Code.serverGeneratedError.rawValue, userInfo: [
                NSLocalizedDescriptionKey: UIStrings.commonProblem.string,
                NSLocalizedRecoverySuggestionErrorKey: localizedString,
                ])
        } else if let readableFallback = serverReadableFallback {
            return NSError(domain: Domain, code: Code.serverGeneratedError.rawValue, userInfo: [
                NSLocalizedDescriptionKey: UIStrings.commonProblem.string,
                NSLocalizedRecoverySuggestionErrorKey: readableFallback,
                ])
        } else {
            return error(with: .serverGeneratedError)
        }
    }

}
