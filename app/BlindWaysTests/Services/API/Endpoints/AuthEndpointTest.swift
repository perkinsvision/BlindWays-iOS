//
//  AuthEndpointTest.swift
//  BlindWaysTests
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

import XCTest
@testable import BlindWays
import Nimble
import Alamofire
import CoreLocation
import OHHTTPStubs

/// Keychain is broken on iOS 10.1 simulator, so run these tests
/// only on iOS 9.x or iOS 10.2+. rdar://27844971 via http://openradar.appspot.com/27844971
private let keychainWorks: Bool = {
    #if arch(i386) || arch(x86_64)
        // On simulator, return false for iOS 10.0 and iOS 10.1.
        if #available(iOS 10.2, *) {
            return true
        } else if #available(iOS 10.0, *) {
            return false
        } else if #available(iOS 10.1, *) {
            return false
        } else {
            return true
        }
    #else
        // On device, assume keychain always works
        return true
    #endif
}()

class AuthEndpointTest: APIEndpointTestCase {

    func testSignUp() {
        let email = "test@perkins.com"
        let password = "password"
        let authToken = "1234XX"

        let routes = RZIRoutes()
        routes.post("/account") { (req, info) -> OHHTTPStubsResponse! in
            let responseJSON = [
                "id": 1,
                "email": email,
                "auth_token": authToken
            ] as [String : Any]
            return OHHTTPStubsResponse(jsonObject: responseJSON, statusCode: 201, headers: nil)
        }
        host.register(routes)

        var resultUser: User?
        client.signUp(email, password: password) { (result) in
            expect(result.isSuccess).to(beTruthy())
            expect(result.value).notTo(beNil())
            expect(result.value?.email).to(equal(email))
            resultUser = result.value
            self.done = true
        }

        expect(self.done).toEventually(beTruthy())

        if keychainWorks {
            expect(self.defaultConfig.authToken).to(equal(authToken))
        }
        expect(resultUser).to(equal(User.loggedInUser))
    }

    func testSignIn() {
        let email = "test@perkins.com"
        let password = "password"
        let authToken = "1234XX"

        let routes = RZIRoutes()
        routes.post("/session") { _, _ -> OHHTTPStubsResponse! in
            let responseJSON = [
                "id": 1,
                "email": email,
                "auth_token": authToken,
            ] as [String : Any]
            return OHHTTPStubsResponse(jsonObject: responseJSON, statusCode: 201, headers: nil)
        }
        host.register(routes)

        var resultUser: User?
        client.signIn(email, password: password) { (result) in
            expect(result.isSuccess).to(beTruthy())
            expect(result.value).notTo(beNil())
            expect(result.value?.email).to(equal(email))
            resultUser = result.value
            self.done = true
        }

        expect(self.done).toEventually(beTruthy())

        if keychainWorks {
            expect(self.defaultConfig.authToken).to(equal(authToken))
        }
        expect(resultUser).to(equal(User.loggedInUser))
    }

    func testSignOut() {
        defaultConfig.authToken = "someToken"

        let routes = RZIRoutes()
        routes.delete("/session") { _, _ -> OHHTTPStubsResponse! in
            return OHHTTPStubsResponse(jsonObject: ["status": "ok"], statusCode: 200, headers: nil)
        }
        host.register(routes)

        client.signOut { (result) in
            expect(result.isSuccess).to(beTruthy())
            expect(result.value).notTo(beNil())
            self.done = true
        }

        expect(self.done).toEventually(beTruthy())

        if keychainWorks {
            expect(self.defaultConfig.authToken).to(equal(""))
        }
        expect(User.loggedInUser).to(beNil())
    }

    func testResetPassword() {
        let email = "test@perkins.com"

        let routes = RZIRoutes()
        routes.post("/reset_password") { (req, info) -> OHHTTPStubsResponse! in
            return OHHTTPStubsResponse(jsonObject: ["status": "ok"], statusCode: 200, headers: nil)
        }
        host.register(routes)

        client.resetPassword(email) { (result) in
            expect(result.isSuccess).to(beTruthy())
            expect(result.value).notTo(beNil())
            self.done = true
        }

        expect(self.done).toEventually(beTruthy())
    }

}
