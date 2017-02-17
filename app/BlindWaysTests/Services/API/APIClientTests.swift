//
//  APIClientTests.swift
//  BlindWaysTests
//
//  Created by Nicholas Bonatsakis on 3/11/16.
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

class APIClientTests: XCTestCase {

    // MARK: helpers

    struct TestEndpoint: APIEndpoint {
        var encoding: Alamofire.ParameterEncoding
        var method: Alamofire.HTTPMethod
        var path: String
        var parameters: [String : Any]?
    }

    class TestableClient: APIClient {
        class TestableManager: Alamofire.SessionManager {
            var done = false
            var mostRecentRequest: URLRequest!

            override func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
                self.mostRecentRequest = try! urlRequest.asURLRequest()
                done = true
                return super.request(urlRequest)
            }
        }

        override func createManager() -> SessionManager {
            return TestableManager()
        }

        var testableManager: TestableManager {
            return self.manager as! TestableManager
        }
    }

    // MARK: Tests

    static let env = APIEnvironment.tests

    let defaultConfig = TokenConfiguration(env: APIClientTests.env)

    func testInit() {
        let client = APIClient(configuration: defaultConfig)
        expect(client).notTo(beNil())
        expect(client.manager).notTo(beNil())
    }

    func testRequest() {
        let client = TestableClient(configuration: defaultConfig)
        client.configuration.agencyID = "1"

        client.request(TestEndpoint(encoding: URLEncoding.default, method: .get, path: "/stops", parameters: nil))

        expect(client.testableManager.done).toEventually(beTruthy())
        let request = client.testableManager.mostRecentRequest
        expect(request!.url).to(equal(client.configuration.env.baseURL.appendingPathComponent("agencies/1/stops")))
    }

}
