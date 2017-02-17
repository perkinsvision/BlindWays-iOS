//
//  AuthViewController.swift
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

import Foundation
import FXForms
import UIKit

class AuthViewController: FormViewController {

    let viewModel: AuthViewModel
    let completionBlock: Block

    // MARK: Init

    init(viewModel: AuthViewModel, isModal: Bool = true, onSuccessBlock: @escaping Block) {
        self.viewModel = viewModel
        self.completionBlock = onSuccessBlock
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = viewModel.localizedTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AuthViewController.doneTapped))
        if isModal {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(AuthViewController.cancelTapped))
        }
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    override func viewDidLoad() {
        super.viewDidLoad()
        formController.form = viewModel
        tableView.tintColor = Colors.Common.darkGrassGreen
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableFooterView = tableFooterView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navBar = navigationController?.navigationBar {
            Appearance.styleNavBar(navBar, color: Colors.Common.darkGrassGreen)
        }
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Accessibility.isVoiceOverRunning() {
            Accessibility.shared.announce(viewModel.localizedTitle, completion: { _, _ in
                self.makeFirstRowResponder()
            })
        } else {
            makeFirstRowResponder()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.endEditing(true)
    }

    // MARK: Responder

    func makeFirstRowResponder() {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? FXFormTextFieldCell {
            cell.textField.becomeFirstResponder()
        }
    }

    // MARK: Actions

    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    func doneTapped() {
        self.tableView.endEditing(true)

        let dismissActivity = rz_showActivityIndicator(in: view, animated: true)
        self.navigationItem.rightBarButtonItem?.isEnabled = false

        do {
            try viewModel.submit { (success, error) in
                dismissActivity(nil)
                self.navigationItem.rightBarButtonItem?.isEnabled = true

                if success {
                    self.completionBlock()
                } else {
                    self.rz_alertError(error)
                }
            }

            Accessibility.shared.announce(viewModel.localizedSavingAccessibilityMessage)

        } catch let error as NSError {
            dismissActivity(nil)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.rz_alertError(error)
        }
    }

    func footerButtonTapped() {
        switch viewModel {
        case let viewModel as SignUpViewModel:
            let signInViewModel = SignInViewModel(client: viewModel.client)
            signInViewModel.email = viewModel.email
            signInViewModel.password = viewModel.password
            let authVC = AuthViewController(viewModel: signInViewModel, onSuccessBlock: completionBlock)
            navigationController?.pushViewController(authVC, animated: true)
        case let viewModel as SignInViewModel:
            showForgotPassword(viewModel: viewModel)
        default: break // No-op
        }
    }

    // MARK: Footer

    var tableFooterView: UIView {
        let button = UIButton(type: .system)
        button.tintColor = Colors.Common.darkGrassGreen
        button.titleLabel?.textAlignment = .center
        button.setAttributedTitle(viewModel.localizedFooterButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(AuthViewController.footerButtonTapped), for: .touchUpInside)
        button.titleLabel?.numberOfLines = 50

        button.sizeToFit()
        button.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: button.bounds.size.height)

        return button
    }

    // MARK: Forgot Password

    func showForgotPassword(viewModel: SignInViewModel) {
        let alert = UIAlertController(title: UIStrings.signinForgotPasswordAlertTitle.string, message: UIStrings.signinForgotPasswordAlertMessage.string, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = UIStrings.signinEmailPlaceholder.string
            textField.keyboardType = .emailAddress
            textField.clearButtonMode = .whileEditing
            textField.text = viewModel.email
        }
        alert.addAction(UIAlertAction(title: UIStrings.commonSubmit.string, style: .default, handler: { _ in
            if let email = alert.textFields?[0].text {
                self.forgotPasswordSubmitTapped(viewModel, email: email)
            }
        }))
        alert.addAction(UIAlertAction(title: UIStrings.commonCancel.string, style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    func forgotPasswordSubmitTapped(_ signInViewModel: SignInViewModel, email: String) {
        let dismissActivity = rz_showActivityIndicator(in: view, animated: true)
        do {
            try signInViewModel.forgotPassword(email) { (success, error) in
                dismissActivity(nil)

                if success {
                    self.rz_alert(UIStrings.commonSuccess.string, message: UIStrings.signinForgotPasswordAlertSuccessMessage(email).string)
                } else {
                    self.rz_alertError(error)
                }
            }
        } catch let error as NSError {
            dismissActivity(nil)
            self.rz_alertError(error)
        }
    }

}
