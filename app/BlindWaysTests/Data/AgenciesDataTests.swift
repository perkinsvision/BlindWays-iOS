//
//  AgenciesDataTests.swift
//  BlindWaysTests
//
//  Created by Fabien Legoupillot on 1/19/17.
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
import CoreLocation

class AgenciesDataTests: DataTestCase {

    func testImportAgencies() {
        let jsonArray = TestData.jsonArrayForFileNamed(DataFilenames.Agencies.list)
        let agencies = Agency.rzi_objects(from: jsonArray) as! [Agency]
        saveContext()

        expect(agencies).to(haveCount(3))

        let agency = agencies.filter { $0.remoteID == 1 }.first!
        expect(agency.remoteID).to(equal(1))
        expect(agency.name).to(equal("MBTA"))
        expect(agency.city).to(equal("Boston"))
        expect(agency.nextBusAgencyID).to(equal("mbta"))
        expect(agency.isSelected).to(equal(false))

        expect(agency.location?.coordinate.latitude).to(beCloseTo(42.3568))
        expect(agency.location?.coordinate.longitude).to(beCloseTo(-71.0572))
    }

}
