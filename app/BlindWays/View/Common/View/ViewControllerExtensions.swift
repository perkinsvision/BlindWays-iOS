//
//  ViewControllerExtensions.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/30/16.
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

// MARK: Empty State

protocol ListViewController: class {
    var tableView: UITableView! { get }
    func emptyStateContentOffset() -> CGPoint

    func per_updateEmptyState(_ viewModel: ListViewModel)
    func per_showEmptyState(_ emptyState: EmptyState)
    func per_hideEmptyState()
}

extension ListViewController where Self: UIViewController {

    func per_updateEmptyState(_ viewModel: ListViewModel) {
        if let emptyState = viewModel.activeEmptyState {
            per_showEmptyState(emptyState)
        } else {
            per_hideEmptyState()
        }
    }

    func per_showEmptyState(_ emptyState: EmptyState) {
        self.rzv_showEmptyState(emptyState, centerOffset: emptyStateContentOffset()) {
            self.tableView.alpha = 0.0
            self.tableView.accessibilityElementsHidden = true
        }
    }

    func per_hideEmptyState() {
        self.rzv_hideEmptyState {
            self.tableView.alpha = 1.0
            self.tableView.accessibilityElementsHidden = false
        }
    }

}

// MARK: Auth Gate

extension UIViewController {

    func per_performAuthenticatedAction(_ alertMessage: String, client: APIClient, actionBlock: @escaping Block) {
        guard User.loggedInUser != nil else {
            per_showAuthPrompt(alertMessage, client: client) {
                actionBlock()
            }
            return
        }

        actionBlock()
    }

    fileprivate func per_showAuthPrompt(_ alertMessage: String, client: APIClient, onAuthSuccess: @escaping Block) {
        let alert = UIAlertController(title: UIStrings.stopDetailAccountRequiredTitle.string, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UIStrings.stopDetailAccountRequiredSignUpButtonTitle.string, style: .default, handler: { _ in
            self.per_showAuth(SignUpViewModel(client: client), completion: onAuthSuccess)
        }))
        alert.addAction(UIAlertAction(title: UIStrings.stopDetailAccountRequiredSignInButtonTitle.string, style: .default, handler: { _ in
            self.per_showAuth(SignInViewModel(client: client), completion: onAuthSuccess)
        }))
        alert.addAction(UIAlertAction(title: UIStrings.commonCancel.string, style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    fileprivate func per_showAuth(_ viewModel: AuthViewModel, completion: @escaping Block) {
        let authVC = AuthViewController(viewModel: viewModel, onSuccessBlock: { [weak self] in
            self?.dismiss(animated: true, completion: {
                completion()
            })
        })

        let nav = UINavigationController(rootViewController: authVC)
        present(nav, animated: true, completion: nil)
    }

}
