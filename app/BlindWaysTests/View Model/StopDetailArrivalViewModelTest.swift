//
//  StopDetailArrivalViewModelTest.swift
//  BlindWaysTests
//
//  Created by Zev Eisenberg on 7/13/16.
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

class StopDetailArrivalViewModelTest: XCTestCase {

    func testArrivalViewModel() {
        let data = TestData.fileDataForName("next_bus_predictions", ext: "xml")
        let results = NextBusPrediction.predictionsFromXML(data: data)

        expect(results).notTo(beNil())
        expect(results).to(haveCount(7))

        let referenceDate = Date(timeIntervalSince1970: 1_459_344_905)

        let nearFuturePrediction = results[0]
        expect(nearFuturePrediction.minutes).to(equal(4))
        let nearFutureViewModel = StopDetailArrivalViewModel(prediction: nearFuturePrediction, relativeToDate: referenceDate)
        expect(nearFutureViewModel.style).to(equal(StopDetailArrivalViewModel.Style.nearFuture))

        let farFuturePrediction = results[4]
        expect(farFuturePrediction.minutes).to(equal(79))
        let farFutureViewModel = StopDetailArrivalViewModel(prediction: farFuturePrediction, relativeToDate: referenceDate)
        expect(farFutureViewModel.style).to(equal(StopDetailArrivalViewModel.Style.farFuture))
    }

}
