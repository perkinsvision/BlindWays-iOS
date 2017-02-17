//
//  RangeClassifierTest.swift
//  BlindWaysTests
//
//  Created by Zev Eisenberg on 7/19/16.
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

class RangeClassifierTest: XCTestCase {

    func testClassifier() {
        let transform = { (upperLimit: Double, value: Double) in
            "\(value) < \(upperLimit)"
        }

        let classifier = RangeClassifier(
            buckets: [
                (upperLimit: 5.0, transform: transform),
                (upperLimit: 15.0, transform: { upperLimit, value in "\(value) < \(upperLimit)" }),
                (upperLimit: 50.0, transform: { upperLimit, value in transform(upperLimit, value) }),
            ],
            outOfBounds: { _ in "Out of bounds" },
            compare: <
        )
        XCTAssertEqual(classifier.classify(3), "3.0 < 5.0")
        XCTAssertEqual(classifier.classify(10), "10.0 < 15.0")
        XCTAssertEqual(classifier.classify(45), "45.0 < 50.0")
        XCTAssertEqual(classifier.classify(50.0), "Out of bounds")
    }

}
