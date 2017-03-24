//
//  SettingsViewModel.swift
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

import Foundation
import FXForms
import Alamofire
import Swiftilities
import CoreLocation

@objc
protocol SettingsActions {

    func settingsDidTapSignIn(_ cell: FXFormFieldCellProtocol)
    func settingsDidTapSignUp(_ cell: FXFormFieldCellProtocol)

    func settingsDidTapChangeEmail(_ cell: FXFormFieldCellProtocol)
    func settingsDidTapChangePassword(_ cell: FXFormFieldCellProtocol)
    func settingsDidTapDeleteAccount(_ cell: FXFormFieldCellProtocol)

    func settingsDidTapChangeAgency(_ cell: FXFormFieldCellProtocol)

    func settingsDidTapLocationServices(_ cell: FXFormFieldCellProtocol)
    func settingsDidTapNotifications(_ cell: FXFormFieldCellProtocol)
    func settingsDidTapNavigationHelper(_ cell: FXFormFieldCellProtocol)

    func settingsDidTapSignOut(_ cell: FXFormFieldCellProtocol)

}

class SettingsViewModel: NSObject, FXForm {

    let client: APIClient
    weak var request: DataRequest?
    lazy var locationManager: CLLocationManager = CLLocationManager()

    var agencyListViewModel: AgenciesListViewModel {
        return AgenciesListViewModel(client: client)
    }

    var emailValidator = FieldValidator(fieldName: UIStrings.signupEmailTitle.string, rules: [
        ValidationRule.nonEmpty,
        ValidationRule.validEmail,
        ])

    var oldPasswordValidator = FieldValidator(fieldName: UIStrings.settingsChangePasswordOldFieldName.string, rules: [
        ValidationRule.nonEmpty,
        ValidationRule.minLength(length: 8),
        ])

    var newPasswordValidator = FieldValidator(fieldName: UIStrings.settingsChangePasswordNewFieldName.string, rules: [
        ValidationRule.nonEmpty,
        ValidationRule.minLength(length: 8),
        ])

    init(client: APIClient) {
        self.client = client
    }

    deinit {
        request?.cancel()
    }

    struct Constants {
        static let errorKey = "non_field_errors"
        static let changePasswordIncorrectPasswordValue = "Unable to log in with provided credentials."
    }

    func fields() -> [Any]! {
        var fields = [[String: Any]]()

        if User.loggedInUser != nil {
            fields.append(contentsOf: authenticatedAccountFields())
        } else {
            fields.append(contentsOf: unauthenticatedAccountFields())
        }

        // Config Fields

        fields.append([
            FXFormFieldHeader: "",
            FXFormFieldTitle: UIStrings.settingsLocationServices.string,
            FXFormFieldKey: #keyPath(locationServicesEnabled),
            FXFormFieldCell: SettingsLinkCell.self,
            SettingsCellKeypaths.accessoryType: UITableViewCellAccessoryType.disclosureIndicator.rawValue,
            FXFormFieldAction: (#selector(SettingsActions.settingsDidTapLocationServices(_:))).description,
            ])

        fields.append([
            FXFormFieldTitle: UIStrings.settingsNotifications.string,
            FXFormFieldKey: #keyPath(notificationsEnabled),
            FXFormFieldCell: SettingsLinkCell.self,
            SettingsCellKeypaths.accessoryType: UITableViewCellAccessoryType.disclosureIndicator.rawValue,
            FXFormFieldAction: (#selector(SettingsActions.settingsDidTapNotifications(_:))).description,
            ])

        fields.append([
            FXFormFieldKey: #keyPath(agency),
            FXFormFieldTitle: UIStrings.settingsAgency.string,
            FXFormFieldCell: SettingsLinkCell.self,
            SettingsCellKeypaths.accessoryType: UITableViewCellAccessoryType.disclosureIndicator.rawValue,
            FXFormFieldAction: (#selector(SettingsActions.settingsDidTapChangeAgency(_:))).description,
            ])

        if NavigationApp.installed.count > 1 {

            fields.append([
                FXFormFieldFooter: UIStrings.settingsNavigationHelperHint.string,
                FXFormFieldTitle: UIStrings.settingsNavigationHelper.string,
                FXFormFieldKey: #keyPath(navigationHelper),
                FXFormFieldCell: SettingsButtonCell.self,
                FXFormFieldAction: (#selector(SettingsActions.settingsDidTapNavigationHelper(_:))).description,
                ])
        }

        // Sign Out Field

        if User.loggedInUser != nil {
            fields.append([
                FXFormFieldHeader: "",
                FXFormFieldTitle: UIStrings.settingsDeleteAccount.string,
                FXFormFieldType: FXFormFieldTypeLabel,
                FXFormFieldCell: SettingsButtonCell.self,
                SettingsCellKeypaths.textColor: Colors.Common.darkOrange,
                FXFormFieldAction: (#selector(SettingsActions.settingsDidTapDeleteAccount(_:))).description,
                ])

            fields.append([
                FXFormFieldTitle: UIStrings.settingsSignOut.string,
                FXFormFieldType: FXFormFieldTypeLabel,
                FXFormFieldCell: SettingsButtonCell.self,
                SettingsCellKeypaths.textColor: Colors.Common.darkOrange,
                FXFormFieldAction: (#selector(SettingsActions.settingsDidTapSignOut(_:))).description,
                ])
        }

        return fields
    }

    // MARK: Auth

    func authenticatedAccountFields() -> [[String: Any]] {
        var fields = [[String: Any]]()

        fields.append([
            FXFormFieldHeader: UIStrings.settingsSectionTitleAccount.string,
            FXFormFieldKey: #keyPath(email),
            FXFormFieldTitle: UIStrings.settingsEmail.string,
            FXFormFieldCell: SettingsEditableValueCell.self,
            FXFormFieldAction: (#selector(SettingsActions.settingsDidTapChangeEmail(_:))).description,
            ])

        fields.append([
            FXFormFieldKey: #keyPath(password),
            FXFormFieldTitle: UIStrings.settingsPassword.string,
            FXFormFieldCell: SettingsEditableValueCell.self,
            FXFormFieldAction: (#selector(SettingsActions.settingsDidTapChangePassword(_:))).description,
            ])

        return fields
    }

    func unauthenticatedAccountFields() -> [[String: Any]] {
        var fields = [[String: Any]]()

        fields.append([
            FXFormFieldHeader: UIStrings.settingsSectionTitleAccount.string,
            FXFormFieldTitle: UIStrings.settingsSignIn.string,
            FXFormFieldType: FXFormFieldTypeLabel,
            FXFormFieldCell: SettingsNavigationCell.self,
            SettingsCellKeypaths.accessoryType: UITableViewCellAccessoryType.disclosureIndicator.rawValue,
            FXFormFieldAction: (#selector(SettingsActions.settingsDidTapSignIn(_:))).description,
            ])

        fields.append([
            FXFormFieldTitle: UIStrings.settingsSignUp.string,
            FXFormFieldType: FXFormFieldTypeLabel,
            FXFormFieldCell: SettingsNavigationCell.self,
            SettingsCellKeypaths.accessoryType: UITableViewCellAccessoryType.disclosureIndicator.rawValue,
            FXFormFieldAction: (#selector(SettingsActions.settingsDidTapSignUp(_:))).description,
            ])

        return fields
    }

    // MARK: Fields

    var email: String? {
        return User.loggedInUser?.email
    }

    var password: String? {
        return UIStrings.settingsChangePassword.string
    }

    var agency: String? {
        return Agency.selectedAgency?.localizedTitle
    }

    var locationServicesEnabled: String {
        return GeoLocator.authorizationStatus == .yes ? UIStrings.commonOn.string : UIStrings.commonOff.string
    }

    var notificationsEnabled: String {
        let types = UIApplication.shared.currentUserNotificationSettings?.types
        return (types != .none && types != []) ? UIStrings.commonOn.string : UIStrings.commonOff.string
    }

    var navigationHelper: String? {
        if let app = NavigationApp.userPreferred {
            return app.localizedTitle
        } else {
            return UIStrings.settingsNavigationHelperNotSet.string
        }
    }

    // MARK: Actions

    typealias SettingsActionCompletion = (Bool, Error?) -> Void

    func changeEmail(_ email: String, completion: @escaping SettingsActionCompletion) throws {
        if let error = emailValidator.validate(email.rz_trimmed) {
            throw error
        }

        request = client.changeEmail(email.rz_trimmed) { (result) in
            completion(result.isSuccess, result.error)
        }
    }

    func changePassword(_ oldPassword: String, newPassword: String, completion: @escaping SettingsActionCompletion) throws {
        if let error = oldPasswordValidator.validate(oldPassword.rz_trimmed) {
            throw error
        }
        if let error = newPasswordValidator.validate(newPassword.rz_trimmed) {
            throw error
        }

        request = client.changePassword(oldPassword.rz_trimmed, newPassword: newPassword.rz_trimmed) { (result) in
            if let error = result.error, let statusCode = (error as NSError).userInfo["StatusCode"] as? Int, statusCode == 400 {
                completion(result.isSuccess, ServiceError.error(with: .invalidChangePassword))
                return
            }

            completion(result.isSuccess, result.error)
        }
    }

    func signOut(_ completion: @escaping SettingsActionCompletion) {
        guard request == nil else {
            Log.error("Request in progress, aborting.")
            return
        }

        request = client.signOut({ (result) in
            completion(result.isSuccess, result.error)
        })
    }

    func deleteAccount(_ completion: @escaping SettingsActionCompletion) {
        guard request == nil else {
            Log.error("Request in progress, aborting.")
            return
        }

        request = client.deleteAccount({ (result) in
            completion(result.isSuccess, result.error)
        })
    }

    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func requestPushAuthorization() {
        FirebaseService.registerForPush()
    }

}
