//
//  APIConfiguration.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/2/16.
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
import KeychainAccess

// MARK: Environment

enum APIEnvironment: String {

    case tests
    case dev
    case staging
    case production

    var baseURL: URL {
        var urlString: String = ""
        switch self {
        case .tests:      urlString = "https://tests.local/v1"
        // PLACEHOLDER - These need to be replaced with your own server, or you need to request
        // access to https://api.blindways.org from Perkins School for the Blind at:
        // http://www.perkins.org/solutions/featured-products/blindways
        case .dev:        urlString = "http://dev-api.placeholder-api.com"
        case .staging:    urlString = "http://stg-api.placeholder-api.com"
        case .production: urlString = "https://api.placeholder-api.com"
        }

        return URL(string: urlString)!
    }

    var readToken: String {
        let token: String?
        switch self {
        case .dev: token = AppConstants.APIReadToken.dev
        case .staging: token = AppConstants.APIReadToken.staging
        case .production: token = AppConstants.APIReadToken.prod
        case .tests: token = nil
        }
        return token ?? ""
    }

}

// MARK: Configuration

protocol APIConfiguration {

    var env: APIEnvironment { get }
    var agencyID: String? { get set }
    var authToken: String? { get set }
    func configureReadToken()

}

class TokenConfiguration: APIConfiguration {

    struct Constants {
        static let keychainIdentifier = AppDelegate.bundleIdentifier
        static let authTokenKey = "authToken"
        static let agencyIDKey = "agencyIDKey"
    }

    let env: APIEnvironment

    var agencyID: String? {
        get {
            return keychain[Constants.agencyIDKey]
        }
        set {
            keychain[Constants.agencyIDKey] = newValue
        }
    }

    var authToken: String? {
        get {
            return keychain[Constants.authTokenKey]
        }
        set {
            keychain[Constants.authTokenKey] = newValue
        }
    }

    fileprivate var keychain: Keychain {
        return Keychain(service: Constants.keychainIdentifier)
    }

    init(env: APIEnvironment) {
        self.env = env
    }

    func configureReadToken() {
        authToken = env.readToken
    }

}
