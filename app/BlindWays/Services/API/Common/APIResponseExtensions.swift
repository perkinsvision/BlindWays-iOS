//
//  APIResponseExtensions.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/7/16.
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
import Alamofire
import CoreData
import RZImport
import RZVinyl
import Swiftilities

// MARK: Serializable Object

protocol APIResponseObjectSerializable {

    static func object(for response: HTTPURLResponse, representation: Any) throws -> Self

}

extension Alamofire.DataRequest {

    func responseObject<T: APIResponseObjectSerializable>(_ completionHandler: @escaping (Result<T>) -> Void) -> Self {
        responseJSON { response in
            if let error = response.result.error {
                completionHandler(.failure(error))
                return
            }

            guard let HTTPresponse = response.response, let value = response.result.value else {
                completionHandler(.failure(ServiceError.error(with: .invalidResponseContent)))
                return
            }

            do {
                let object = try T.object(for: HTTPresponse, representation: value)
                completionHandler(.success(object))
            } catch {
                completionHandler(.failure(error))
            }
        }
        return self
    }

}

// MARK: Serializable Collection

protocol APIResponseCollectionSerializable {

    static func collection(for response: HTTPURLResponse, representation: Any) throws -> [Self]

}

extension Alamofire.DataRequest {

    func responseCollection<T: APIResponseCollectionSerializable>(_ completionHandler: @escaping (Result<[T]>) -> Void) -> Self {
        responseJSON { response in
            if let error = response.result.error {
                completionHandler(.failure(error))
                return
            }

            guard let HTTPresponse = response.response, let value = response.result.value else {
                completionHandler(.failure(ServiceError.error(with: .invalidResponseContent)))
                return
            }

            do {
                let object = try T.collection(for: HTTPresponse, representation: value)
                completionHandler(.success(object))
            } catch {
                completionHandler(.failure(error))
            }
        }
        return self
    }

}

// MARK: Import Object

extension Alamofire.DataRequest {

    @discardableResult func responseImportedObject<T: NSManagedObject>(_ completionHandler: @escaping (Result<T>) -> Void) -> Self where T: RZImportable {
        responseJSON { response in
            if let error = response.result.error {
                completionHandler(.failure(error))
                return
            }

            guard let value = response.result.value, let jsonDict = value as? [String: Any] else {
                completionHandler(.failure(ServiceError.error(with: .invalidResponseContent)))
                return
            }

            let stack = RZCoreDataStack.default()
            var importedObject: T?

            stack.performBlock(backgroundContext: { context in
                importedObject = T.rzi_object(from: jsonDict, in: context)
            }, completion: { error in
                if let error = error {
                    completionHandler(.failure(error))
                } else if let persistedObjectID = importedObject?.objectID,
                    let object = stack.mainManagedObjectContext.object(with: persistedObjectID) as? T {
                    completionHandler(.success(object))
                }
            })
        }
        return self
    }

}

// MARK: Import Collection

extension Alamofire.DataRequest {

    @discardableResult func responseImportedCollection<T: NSManagedObject>(_ completionHandler: @escaping (Result<[T]>) -> Void) -> Self where T: RZImportable {
        responseJSON { response in
            if let error = response.result.error {
                completionHandler(.failure(error))
                return
            }

            guard let value = response.result.value, let jsonArray = value as? [[String: Any]] else {
                completionHandler(.failure(ServiceError.error(with: .invalidResponseContent)))
                return
            }

            let stack = RZCoreDataStack.default()
            var importedObjects: [T] = [T]()

            stack.performBlock(backgroundContext: { context in
                for obj in jsonArray {
                    let importedObject = T.rzi_object(from: obj, in: context)
                    importedObjects.append(importedObject)
                }
            }, completion: { error in
                if let error = error {
                    completionHandler(.failure(error))
                } else {
                    let objectIDs = importedObjects.map({ $0.objectID })
                    var results = [T]()
                    for persistedObjectID in objectIDs {
                        if let object = stack.mainManagedObjectContext.object(with: persistedObjectID) as? T {
                            results.append(object)
                        }
                    }
                    completionHandler(.success(results))
                }
            })
        }
        return self
    }

}
