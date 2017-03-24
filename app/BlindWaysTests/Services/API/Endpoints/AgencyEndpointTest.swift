//
//  AgencyEndpointTest.swift
//  BlindWaysTests
//
//  Created by Fabien Legoupillot on 1/18/17.
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
import OHHTTPStubs

class AgenciesEndpointTest: APIEndpointTestCase {

    func testList() {
        let routes = RZIRoutes()

        routes.get("/agencies") { (_, info) -> OHHTTPStubsResponse! in
            let params = info?[kRZIRequestQueryParametersKey] as! [String: Any]
            expect(params).to(beEmpty())

            return OHHTTPStubsResponse(jsonObject: TestData.jsonArrayForFileNamed(DataFilenames.Agencies.list),
                                       statusCode: 200,
                                       headers: nil)
        }

        host.register(routes)

        waitUntil { (done) in
            self.client.allAgencies() { result in
                expect(result.value).to(haveCount(3))
                done()
            }
        }

        let agencies = Agency.rzv_all()
        expect(agencies).to(haveCount(3))
    }
    
}
