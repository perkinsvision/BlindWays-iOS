//
//  StopsEndpointTest.swift
//  BlindWaysTests
//
//  Created by Nicholas Bonatsakis on 3/15/16.
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

class StopsEndpointTest: APIEndpointTestCase {

    func testNearby() {
        client.configuration.agencyID = "1"

        let routes = RZIRoutes()
        routes.get("/agencies/1/stops/search") { (_, info) -> OHHTTPStubsResponse! in
            let params = info?[kRZIRequestQueryParametersKey] as! [String: Any]
            expect(params["lat"] as? String).to(equal("42.357029"))
            expect(params["lng"] as? String).to(equal("-71.057676"))
            expect(params["distance"] as? String).to(equal("2000"))
            expect(params["limit"] as? String).to(equal("3"))
            return OHHTTPStubsResponse(jsonObject: TestData.jsonArrayForFileNamed(DataFilenames.Stops.search), statusCode: 200, headers: nil)
        }
        host.register(routes)

        waitUntil { (done) in
            self.client.nearbyStops(location: CLLocation(latitude: 42.357029, longitude: -71.057676)) { result in
                expect(result.value).to(haveCount(3))
                done()
            }
        }

        let stops = Stop.rzv_all()
        expect(stops).notTo(beNil())
        expect(stops).to(haveCount(3))
    }

}
