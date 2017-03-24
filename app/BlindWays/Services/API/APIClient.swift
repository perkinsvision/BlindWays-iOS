//
//  APIClient.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 2/5/16.
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
import Swiftilities

class APIClient {

    static let authErrorNotification = AppDelegate.reverseDomain("authErrorNotification")

    struct Constants {

        struct Headers {

            static let authName = "Authorization"
            static let bearerValueFormat = "Token %@"

        }

    }

    var configuration: APIConfiguration
    lazy var manager: Alamofire.SessionManager = self.createManager()

    // MARK: Init

    init(configuration: APIConfiguration) {
        self.configuration = configuration
    }

    func createManager() -> SessionManager {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        return Alamofire.SessionManager(configuration: config, serverTrustPolicyManager: nil)
    }

    // MARK: Execution

    @discardableResult func request(_ endpoint: APIEndpoint) -> DataRequest {
        let authBlock = {
            self.destroyAccount()
        }
        return manager.request(configuration, endpoint: endpoint).onAuthError(authBlock).validate(statusCode: 200...399)
    }

}

// MARK: Auth. Error

private extension DataRequest {

    func onAuthError(_ block: @escaping Block) -> Self {
        return validate { (_, response, _) in
            if response.statusCode == 401 {
                OperationQueue.main.addOperation {
                    block()
                }
            }

            return .success
        }

    }

}
