//
//  TimerTest.swift
//  BlindWaysTests
//
//  Created by Zev Eisenberg on 6/28/16.
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

class TimerTest: XCTestCase {

    var timer: DispatchTimer?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        timer?.pause()
    }

    func testTimer() {
        let expectation = self.expectation(description: "timer test")

        var counter = 4
        timer = DispatchTimer(interval: 0.1, queue: DispatchQueue.main, leeway: 0) {
            counter -= 1
            if counter == 0 {
                expectation.fulfill()
            }
        }
        timer?.resume()

        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error)
        }

        XCTAssertLessThanOrEqual(counter, 0)
    }

    func testTimerCancellation() {
        let expectation = self.expectation(description: "timer cancellation test")

        var counter = 5
        var countedAllTheWayDown = false
        timer = DispatchTimer(interval: 0.1, queue: DispatchQueue.main, leeway: 0) {
            counter -= 1
            if counter == 0 {
                countedAllTheWayDown = true
            }
        }
        timer?.resume()

        Utility.performAfter(0.2) {
            self.timer?.pause()
            Utility.performAfter(1.0, block: {
                expectation.fulfill()
            })
        }

        waitForExpectations(timeout: 1.5) { error in
            XCTAssertNil(error)
        }

        XCTAssertFalse(countedAllTheWayDown)
    }

    func testTimerResuming() {
        let expectation = self.expectation(description: "timer resuming test")

        var counter = 10
        var countedAllTheWayDown = false
        timer = DispatchTimer(interval: 0.1, queue: DispatchQueue.main, leeway: 0) {
            counter -= 1
            if counter <= 0 {
                countedAllTheWayDown = true
            }
        }
        timer?.resume()

        Utility.performAfter(0.2) {
            self.timer?.pause()
            Utility.performAfter(0.1, block: {
                self.timer?.resume()
                Utility.performAfter(1.0, block: {
                    expectation.fulfill()
                })
            })
        }

        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error)
        }

        XCTAssertTrue(countedAllTheWayDown)
    }

}
