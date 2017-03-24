//
//  SettingsViewController.swift
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
import RZUtils
import MessageUI
import Swiftilities
import CoreLocation

class SettingsViewController: FormViewController {

    let viewModel: SettingsViewModel

    // MARK: Init

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = UIStrings.settingsTitle.string
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: UIStrings.commonClose.string, style: .plain, target: self, action: #selector(SettingsViewController.doneTapped))

        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.handleAppDidBecomeActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    override func viewDidLoad() {
        super.viewDidLoad()
        formController.form = viewModel
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableFooterView = RZAbout.rzLogoViewConstrained(toWidth: tableView.bounds.width)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = navigationController {
            Appearance.styleNavBar(nav.navigationBar, color: Colors.Common.darkGrassGreen)
        }
        self.smoothlyDeselectItems(tableView)
        // forces a reload of just section zero to allow the smooth deselect to run, and to force the agency to update 
        guard tableView.numberOfSections > 1 else {
            return
        }
        tableView.reloadSections([1], with: .none)
    }

    // MARK: Actions

    func doneTapped() {
        Appearance.styleNavBar(UINavigationBar.appearance(), color: Colors.Common.marineBlue)
        dismiss(animated: true, completion: nil)
    }

    // MARK: Form

    func reloadForm() {
        formController.form = viewModel
        tableView.reloadData()
    }

    // MARK: Notifications

    func handleAppDidBecomeActive() {
        reloadForm()
    }

}

// MARK: Account Actions

extension SettingsViewController: SettingsActions {

    // MARK: Auth

    func settingsDidTapSignIn(_ cell: FXFormFieldCellProtocol) {
        presentAuth(viewModel: SignInViewModel(client: viewModel.client))
    }

    func settingsDidTapSignUp(_ cell: FXFormFieldCellProtocol) {
        presentAuth(viewModel: SignUpViewModel(client: viewModel.client))
    }

    func settingsDidTapChangeAgency(_ cell: FXFormFieldCellProtocol) {
        let agencySelect = AgenciesListViewController(viewModel: viewModel.agencyListViewModel, mode: .manualUpdate)
        let navigation = UINavigationController(rootViewController: agencySelect)
        present(navigation, animated: true, completion: nil)
    }

    fileprivate func presentAuth(viewModel: AuthViewModel) {
        let authVC = AuthViewController(viewModel: viewModel, isModal: false, onSuccessBlock: { [weak self] in
            self?.reloadForm()
            // Pop to root, rather than just popping, because we may be more than
            // one level down if, for example, we go to Join, and then push
            // from there to Sign In because the user remembered that they have an
            // account after all.
            _ = self?.navigationController?.popToRootViewController(animated: true)
        })
        navigationController?.pushViewController(authVC, animated: true)
    }

    func settingsDidTapChangeEmail(_ cell: FXFormFieldCellProtocol) {
        let alert = UIAlertController(title: UIStrings.settingsChangeEmailAlertTitle.string,
                                      message: UIStrings.settingsChangeEmailAlertMessage.string,
                                      preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = UIStrings.settingsChangeEmailAlertPlaceholder.string
            textField.keyboardType = .emailAddress
            textField.clearButtonMode = .whileEditing
            textField.text = User.loggedInUser?.email ?? ""
        }
        alert.addAction(UIAlertAction(title: UIStrings.commonSubmit.string, style: .default, handler: { _ in
            if let email = alert.textFields?[0].text {
                self.changeEmailSubmitTapped(email: email)
            }
        }))
        alert.addAction(UIAlertAction(title: UIStrings.commonCancel.string, style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    fileprivate func changeEmailSubmitTapped(email: String) {
        let dismissActivity = rz_showActivityIndicator(in: view, animated: true)
        do {
            try viewModel.changeEmail(email) { (success, error) in
                dismissActivity(nil)

                if success {
                    self.rz_alert(UIStrings.settingsChangeEmailAlertSuccessTitle.string, message: UIStrings.settingsChangeEmailAlertSuccessMessage(email).string)
                    self.reloadForm()
                } else {
                    self.rz_alertError(error as NSError?)
                }
            }
        } catch let error as NSError {
            dismissActivity(nil)
            self.rz_alertError(error)
        }
    }

    func settingsDidTapChangePassword(_ cell: FXFormFieldCellProtocol) {
        showChangePassword()
    }

    fileprivate func showChangePassword() {
        let alert = UIAlertController(title: UIStrings.settingsChangePasswordAlertTitle.string,
                                      message: UIStrings.settingsChangePasswordAlertMessage.string,
                                      preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.isSecureTextEntry = true
            textField.placeholder = UIStrings.settingsChangePasswordAlertOldPlaceholder.string
            textField.clearButtonMode = .whileEditing
        }
        alert.addTextField { (textField) in
            textField.isSecureTextEntry = true
            textField.placeholder = UIStrings.settingsChangePasswordAlertNewPlaceholder.string
            textField.clearButtonMode = .whileEditing
        }

        alert.addAction(UIAlertAction(title: UIStrings.commonSubmit.string, style: .default, handler: { _ in
            if let oldPassword = alert.textFields?[0].text, let newPassword = alert.textFields?[1].text {
                self.changePasswordSubmitTapped(oldPassword: oldPassword, newPassword: newPassword)
            }
        }))
        alert.addAction(UIAlertAction(title: UIStrings.commonCancel.string, style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    fileprivate func changePasswordSubmitTapped(oldPassword: String, newPassword: String) {
        let dismissActivity = rz_showActivityIndicator(in: view, animated: true)
        do {
            try viewModel.changePassword(oldPassword, newPassword: newPassword) { (success, error) in
                dismissActivity(nil)

                if success {
                    self.rz_alert(UIStrings.settingsChangePasswordAlertSuccessTitle.string, message: UIStrings.settingsChangePasswordAlertSuccessMessage.string)
                } else {
                    self.rz_alertError(error as NSError?) {
                        self.showChangePassword()
                    }
                }
            }
        } catch let error as NSError {
            dismissActivity(nil)
            self.rz_alertError(error) {
                self.showChangePassword()
            }
        }
    }

    func settingsDidTapDeleteAccount(_ cell: FXFormFieldCellProtocol) {
        let alert = UIAlertController(title: nil, message: UIStrings.settingsDeleteAccountAlertButtonTitle.string, preferredStyle: .actionSheet)
        alert.message = UIStrings.settingsDeleteAccountAlertMessage.string
        alert.addAction(UIAlertAction(title: UIStrings.settingsDeleteAccountAlertButtonTitle.string, style: .destructive, handler: { _ in
            self.deleteAccount()
        }))
        alert.addAction(UIAlertAction(title: UIStrings.commonCancel.string, style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    fileprivate func deleteAccount() {
        let dismissActivity = rz_showActivityIndicator(in: view, animated: true)

        viewModel.deleteAccount { (success, error) in
            dismissActivity(nil)
            if success {
                self.reloadForm()
            } else {
                self.rz_alertError(error as NSError?)
            }
        }
    }

    // MARK: Config

    func settingsDidTapLocationServices(_ cell: FXFormFieldCellProtocol) {
        if GeoLocator.authorizationStatus == .unknown {
            viewModel.requestLocationAuthorization()
        } else {
            UIApplication.shared.sendAction(#selector(CommonActions.launchAppSettings), to: nil, from: self, for: nil)
        }
    }

    func settingsDidTapNotifications(_ cell: FXFormFieldCellProtocol) {
        if !Defaults.shared.read(UserDefaultsKeys.hasSeenNotificationPrompt) {
            viewModel.requestPushAuthorization()
        } else {
            UIApplication.shared.sendAction(#selector(CommonActions.launchAppSettings), to: nil, from: self, for: nil)
        }
    }

    func settingsDidTapNavigationHelper(_ cell: FXFormFieldCellProtocol) {
        let alert = UIAlertController(title: nil,
                                      message: UIStrings.settingsNavigationHelperSelectMessage.string,
                                      preferredStyle: .actionSheet)

        for app in NavigationApp.installed {
            alert.addAction(UIAlertAction(title: app.localizedTitle, style: .default) { _ in
                NavigationApp.userPreferred = app
                self.reloadForm()
            })
        }

        alert.addAction(UIAlertAction(title: UIStrings.commonCancel.string, style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    func settingsDidTapSignOut(_ cell: FXFormFieldCellProtocol) {
        let alert = UIAlertController(title: nil, message: UIStrings.settingsSignOutAlertMessage.string, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UIStrings.settingsSignOut.string, style: .destructive, handler: { _ in
            self.signOut()
        }))
        alert.addAction(UIAlertAction(title: UIStrings.commonCancel.string, style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    fileprivate func signOut() {
        let dismissActivity = rz_showActivityIndicator(in: view, animated: true)

        viewModel.signOut { (success, error) in
            dismissActivity(nil)
            if success {
                self.reloadForm()
            } else {
                self.rz_alertError(error as NSError?)
            }
        }
    }

}
