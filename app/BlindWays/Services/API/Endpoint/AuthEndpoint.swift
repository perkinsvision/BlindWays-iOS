//
//  AuthEndpoint.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/7/16.
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
import Alamofire

// MARK: Endpoint

enum Auth {

    case signUp(email: String, password: String)
    case signIn(email: String, password: String)
    case signOut
    case resetPassword(email: String)
    case changeEmail(email: String)
    case changePassword(oldPassword: String, newPassword: String)
    case deleteAccount

    struct Notification {

        struct Name {

            static let userSignedIn = AppDelegate.reverseDomain("UserSignedIn")
            static let userSignedOut = AppDelegate.reverseDomain("UserSignedOut")

        }

        struct Key {

            static let userID = AppDelegate.reverseDomain("UserNotificationKeyUserID")

        }

    }

    struct Constants {

        static let emailKey       = "email"
        static let passwordKey    = "password"
        static let oldPasswordKey = "old_password"
        static let authTokenKey   = "auth_token"

    }

}

extension Auth: APIEndpoint {

    var encoding: Alamofire.ParameterEncoding {
        return Alamofire.JSONEncoding.default
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .signOut, .deleteAccount: return .delete
        default: return .post
        }
    }

    var path: String {
        switch self {
        case .signUp, .deleteAccount: return "/account"
        case .signIn, .signOut: return "/session"
        case .resetPassword: return "/reset_password"
        case .changeEmail: return "/change_email"
        case .changePassword: return "/change_password"
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .signUp(let email, let password): return [
            Constants.emailKey: email,
            Constants.passwordKey: password,
        ]
        case .signIn(let email, let password): return [
            Constants.emailKey: email,
            Constants.passwordKey: password,
        ]
        case .resetPassword(let email): return [
            Constants.emailKey: email,
        ]
        case .changeEmail(let email): return [
            Constants.emailKey: email,
        ]
        case .changePassword(let oldPassword, let newPassword): return [
            Constants.oldPasswordKey: oldPassword,
            Constants.passwordKey: newPassword,
        ]
        default: return nil
        }
    }

    var prependAgency: Bool {
        return false
    }

}

// MARK: Client

extension APIClient {

    typealias SignUpCompletion = (Alamofire.Result<User>) -> Void

    @discardableResult func signUp(_ email: String, password: String, completion: @escaping SignUpCompletion) -> DataRequest {
        let endpoint = Auth.signUp(email: email, password: password)
        return authUserRequest(endpoint, completion: completion)
    }

    @discardableResult func signIn(_ email: String, password: String, completion: @escaping SignUpCompletion) -> DataRequest {
        let endpoint = Auth.signIn(email: email, password: password)
        return authUserRequest(endpoint, completion: completion)
    }

    fileprivate func authUserRequest(_ endpoint: Auth, completion: @escaping SignUpCompletion) -> DataRequest {
        return request(endpoint).responseJSONWithError { response in
            switch response.result {
            case .success(let jsonAny):
                if let jsonDict = jsonAny as? [String: Any],
                let email = jsonDict[Auth.Constants.emailKey] as? String,
                let remoteID = jsonDict[APIConstants.Common.ExternalKeys.id] as? Int64,
                let authToken = jsonDict[Auth.Constants.authTokenKey] as? String, response.result.isSuccess {
                    self.configuration.authToken = authToken

                    let user = User.rzv_new()
                    user.remoteID = remoteID
                    user.email = email

                    do {
                        try user.managedObjectContext?.rzv_saveToStoreAndWait()
                        completion(.success(user))
                    } catch {
                        completion(.failure(error))
                        return
                    }

                    NotificationCenter.default.post(
                        name: Notification.Name(Auth.Notification.Name.userSignedIn),
                        object: self,
                        userInfo: [
                            Auth.Notification.Key.userID: "\(user.remoteID)",
                        ])
                } else {
                    completion(.failure(ServiceError.error(with: .invalidResponseContent)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    typealias JSONCompletion = (Alamofire.Result<Any>) -> Void

    @discardableResult func resetPassword(_ email: String, completion: @escaping JSONCompletion) -> DataRequest {
        let endpoint = Auth.resetPassword(email: email)
        return request(endpoint).responseJSONWithError { (response) in
            completion(response.result)
        }
    }

    func changeEmail(_ email: String, completion: @escaping JSONCompletion) -> DataRequest {
        let endpoint = Auth.changeEmail(email: email)
        return request(endpoint).responseJSONWithError { (response) in
            if response.result.isSuccess {
                do {
                    if let user = User.loggedInUser {
                        user.email = email
                        try user.managedObjectContext?.rzv_saveToStoreAndWait()
                    }
                } catch {
                    completion(.failure(error))
                }
            }

            completion(response.result)
        }
    }

    func changePassword(_ oldPassword: String, newPassword: String, completion: @escaping JSONCompletion) -> DataRequest {
        let endpoint = Auth.changePassword(oldPassword: oldPassword, newPassword: newPassword)
        return request(endpoint).responseJSONWithError { (response) in
            completion(response.result)
        }
    }

    @discardableResult func signOut(_ completion: @escaping JSONCompletion) -> DataRequest {
        let endpoint = Auth.signOut
        return destroyAccount(endpoint, completion: completion)
    }

    func deleteAccount(_ completion: @escaping JSONCompletion) -> DataRequest {
        let endpoint = Auth.deleteAccount
        return destroyAccount(endpoint, completion: completion)
    }

    func destroyAccount(_ endpoint: Auth, completion: @escaping JSONCompletion) -> DataRequest {
        return request(endpoint).responseJSONWithError { (response) in
            if response.result.isSuccess {
                self.destroyAccount()
            }

            completion(response.result)
        }
    }

    func destroyAccount() {
        self.configuration.configureReadToken()
        if let user = User.loggedInUser {
            NotificationCenter.default.post(
                name: Notification.Name(Auth.Notification.Name.userSignedOut),
                object: self,
                userInfo: [
                    Auth.Notification.Key.userID: "\(user.remoteID)",
                ])
        }

        CoreDataStack.default().clearUserData()
    }

}
