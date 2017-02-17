//
//  Utility.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/21/16.
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

typealias cancel_token_t = UnsafeMutablePointer<Bool>

typealias Block = () -> Void

public func degreesToRadians(_ degrees: Double) -> Double {
    return degrees * M_PI / 180.0
}

public func radiansToDegrees(_ radians: Double) -> Double {
    return radians * 180.0 / M_PI
}

struct Utility {

    static func objectClassName(_ object: AnyObject) -> String {
        return String(describing: type(of: object)).components(separatedBy: ".").last!
    }

    static func performOnMainThread(_ block: @escaping Block) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }

    ///  Performs a given block no sooner than `delay` seconds from now.
    ///
    ///  - parameter delay: The minimum number of seconds to wait before performing `block`.
    ///  - parameter block: The action to perform.
    ///
    ///  - returns: A cancellation token. To cancel the block, do:
    ///
    ///    if token != nil {
    ///        token.memory = true
    ///    }
    ///
    ///  - remark: The cancellation token can probably be cleaned up, or replaced with `DispatchWorkItem.cancel()`.
    @discardableResult static func performAfter(_ delay: TimeInterval, block: @escaping Block) -> cancel_token_t {
        let cancelToken = cancel_token_t.allocate(capacity: 1)

        let time = DispatchTime.now() + Double(Int64(delay * TimeInterval(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            if cancelToken.pointee == false {
                block()
            }

            cancelToken.deinitialize()
        }

        return cancelToken
    }

    /**
     *  Casts object as the given type. On failure, logs an error and terminates.
     */

    @inline(__always) static func forceCast<T>(_ value: Any?, asType type: T.Type) -> T {
        guard let value = value else {
            preconditionFailure("Expected value of type \(T.self), got nil.")
        }

        guard let typedValue = value as? T else {
            preconditionFailure("Expected object of type \(T.self), got \(type(of: (value))).")
        }

        return typedValue
    }

}
