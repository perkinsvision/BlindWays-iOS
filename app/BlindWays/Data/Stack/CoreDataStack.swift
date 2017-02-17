//
//  CoreDataStack.swift
//  BlindWays
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

import Foundation
import RZVinyl
import CoreData
import Swiftilities

class CoreDataStack: RZCoreDataStack {

    static let defaultModelName = "BlindWays"

    override class func `default`() -> CoreDataStack {
        // swiftlint:disable force_cast
        return super.default() as! CoreDataStack
        // swiftlint:enable force_cast
    }

    // MARK: Helpers

    func resetDatabase() {
        do {
            let entities = self.managedObjectModel.entities
            for entityName in entities.flatMap({ $0.name }) {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                request.predicate = NSPredicate(value: true)
                for case let obj as NSManagedObject in try self.mainManagedObjectContext.fetch(request) {
                    self.mainManagedObjectContext.delete(obj)
                }
            }

            try self.mainManagedObjectContext.rzv_saveToStoreAndWait()
        } catch {
            Log.error("Failure resetting database: \(error)")
        }
    }

    func clearUserData() {
        do {
            if let user = User.loggedInUser {
                self.mainManagedObjectContext.delete(user)
            }

            try self.mainManagedObjectContext.rzv_saveToStoreAndWait()
        } catch {
            Log.error("Failure clearing user data: \(error)")
        }
    }

}

// MARK: Core Data

struct CoreDataConfiguration: AppLifecycleConfigurable {

    func onDidLaunch(_ application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        if let dataStack = CoreDataStack(modelName: CoreDataStack.defaultModelName, configuration: nil, storeType: nil, store: nil, options: [.deleteDatabaseIfUnreadable]) {
            CoreDataStack.setDefault(dataStack)
        }
    }

}
