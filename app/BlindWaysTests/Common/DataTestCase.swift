//
//  DataTestCase.swift
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
import RZVinyl
import Nimble

class DataTestCase: XCTestCase {

    var dataStack: CoreDataStack!

    override class func setUp() {
        super.setUp()
        Nimble.AsyncDefaults.Timeout = 5
        Nimble.AsyncDefaults.PollInterval = 0.1
    }

    override func setUp() {
        super.setUp()
        dataStack = CoreDataStack(modelName: CoreDataStack.defaultModelName, configuration: nil, storeType: nil, store: nil, options: [.deleteDatabaseIfUnreadable])!
        CoreDataStack.setDefault(dataStack)
        CoreDataStack.default().resetDatabase()
    }

    override func tearDown() {
        super.tearDown()
        CoreDataStack.default().resetDatabase()
    }

    func saveContext() {
        do {
            try dataStack.mainManagedObjectContext.rzv_saveToStoreAndWait()
        } catch {
            XCTFail("Save context failed: \(error)")
        }
    }

}
