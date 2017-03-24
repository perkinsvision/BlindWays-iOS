//
//  UserDefaults.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 5/2/16.
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
import Swiftilities

struct UserDefaultsKey<T>: RawRepresentable {

    var rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

class Defaults {

    /**
     Determines the action that should be taken when an object of unexpected type is read from UserDefaults.

     - Ignore:    Simply return nil.
     - Log:       Log the error using `print`, and return nil.
     - Assert:    Trigger an `assertionFailure`, and return nil.
     - Terminate: Terminate the app with `preconditionFailure`.
     */
    enum TypeMismatchMode {
        case Ignore
        case Log
        case Assert
        case Terminate
    }

    static let standardDefaults = UserDefaults.standard

    static let shared: Defaults = Defaults()

    let keyPrefix: String?
    var typeMismatchMode = TypeMismatchMode.Assert

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard, keyPrefix: String? = Bundle(for: Defaults.self).bundleIdentifier) {
        self.userDefaults = userDefaults
        self.keyPrefix = keyPrefix
    }

    // MARK: - Reading

    func read(_ key: UserDefaultsKey<Data>) -> Data? {
        return castObject(userDefaults.object(forKey: prefixedKey(key)), asType: Data.self)
    }

    func read(_ key: UserDefaultsKey<Date>) -> Date? {
        return castObject(userDefaults.object(forKey: prefixedKey(key)), asType: Date.self)
    }

    func read<T: NSCoding>(_ key: UserDefaultsKey<T>) -> T? {
        guard let data = castObject(userDefaults.object(forKey: prefixedKey(key)), asType: Data.self) else {
            return nil
        }

        return castObject(NSKeyedUnarchiver.unarchiveObject(with: data), asType: T.self)
    }

    func read(_ key: UserDefaultsKey<String>) -> String? {
        return castObject(userDefaults.object(forKey: prefixedKey(key)), asType: String.self)
    }

    func read<T>(_ key: UserDefaultsKey<[T]>) -> [T]? {
        return castObject(userDefaults.object(forKey: prefixedKey(key)), asType: [T].self)
    }

    func read<T>(_ key: UserDefaultsKey<[String: T]>) -> [String: T]? {
        return castObject(userDefaults.object(forKey: prefixedKey(key)), asType: [String: T].self)
    }

    func read(_ key: UserDefaultsKey<Bool>) -> Bool {
        return userDefaults.bool(forKey: prefixedKey(key))
    }

    func read(_ key: UserDefaultsKey<Int>) -> Int {
        return userDefaults.integer(forKey: prefixedKey(key))
    }

    func read(_ key: UserDefaultsKey<Float>) -> Float {
        return userDefaults.float(forKey: prefixedKey(key))
    }

    func read(_ key: UserDefaultsKey<Double>) -> Double {
        return userDefaults.double(forKey: prefixedKey(key))
    }

    // MARK: - Writing

    func write(_ value: Data?, forKey key: UserDefaultsKey<Data>) {
        userDefaults.set(value, forKey: prefixedKey(key))
    }

    func write(_ value: Date?, forKey key: UserDefaultsKey<Date>) {
        userDefaults.set(value, forKey: prefixedKey(key))
    }

    func write<T: NSCoding>(_ value: T?, forKey key: UserDefaultsKey<T>) {
        let fullKey = prefixedKey(key)

        if let value = value {
            userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: fullKey)
        } else {
            userDefaults.set(nil, forKey: fullKey)
        }
    }

    func write<T>(_ value: [T]?, forKey key: UserDefaultsKey<[T]>) {
        let fullKey = prefixedKey(key)

        if let value = value {
            userDefaults.set(NSArray(array: value), forKey: prefixedKey(key))
        } else {
            userDefaults.set(nil, forKey: fullKey)
        }
    }

    func write<T>(_ value: [String: T]?, forKey key: UserDefaultsKey<[String: T]>) {
        let fullKey = prefixedKey(key)

        if let value = value {
            userDefaults.set(NSDictionary(dictionary: value), forKey: fullKey)
        } else {
            userDefaults.set(nil, forKey: prefixedKey(key))
        }
    }

    func write(_ value: String?, forKey key: UserDefaultsKey<String>) {
        let fullKey = prefixedKey(key)

        if let value = value {
            userDefaults.set(NSString(string: value), forKey: fullKey)
        } else {
            userDefaults.set(nil, forKey: fullKey)
        }
    }

    func write(_ value: Bool, forKey key: UserDefaultsKey<Bool>) {
        userDefaults.set(value, forKey: prefixedKey(key))
    }

    func write(_ value: Int, forKey key: UserDefaultsKey<Int>) {
        userDefaults.set(value, forKey: prefixedKey(key))
    }

    func write(_ value: Float, forKey key: UserDefaultsKey<Float>) {
        userDefaults.set(value, forKey: prefixedKey(key))
    }

    func write(_ value: Double, forKey key: UserDefaultsKey<Double>) {
        userDefaults.set(value, forKey: prefixedKey(key))
    }

    // MARK: - Clearing

    func remove<T>(key: UserDefaultsKey<T>) {
        remove(keys: [key])
    }

    func remove<T>(keys: [UserDefaultsKey<T>]) {
        keys.forEach { userDefaults.removeObject(forKey: prefixedKey($0)) }
    }

}

// MARK: - Private

private extension Defaults {

    func prefixedKey<T>(_ key: UserDefaultsKey<T>) -> String {
        if let keyPrefix = keyPrefix {
            return "\(keyPrefix).\(key.rawValue)"
        }
        return key.rawValue
    }

    func castObject<T>(_ object: Any?, asType type: T.Type) -> T? {
        guard let object = object else {
            return nil
        }

        guard let typedObject = object as? T else {
            let errorDescription = "UserDefaults expected object of type \(T.self), got \(type(of: object))."

            switch typeMismatchMode {
            case .Log:
                Log.error(errorDescription)
            case .Assert:
                assertionFailure(errorDescription)
            case .Terminate:
                preconditionFailure(errorDescription)
            default:
                break
            }

            return nil
        }

        return typedObject
    }

}
