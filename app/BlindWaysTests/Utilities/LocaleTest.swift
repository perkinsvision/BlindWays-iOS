//
//  LocaleTest.swift
//  BlindWaysTests
//
//  Created by Zev Eisenberg on 11/16/16.
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
import Foundation
@testable import BlindWays

class LocaleTest: XCTestCase {

    func testIsMetric() {
        let en_US = Locale(identifier: "en_US")
        XCTAssertFalse(en_US.isMetric)

        let fr = Locale(identifier: "fr")
        XCTAssertTrue(fr.isMetric)
    }

}
