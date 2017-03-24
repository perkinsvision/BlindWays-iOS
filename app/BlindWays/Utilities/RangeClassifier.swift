//
//  RangeClassifier.swift
//  BlindWays
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

// Created with help from:
// Olivier Halligon: https://twitter.com/aligatr
// Soroush Khanlou: https://twitter.com/khanlou

/// Classifies a comparable value of type `Value` into “buckets” of type `Classification`.
/// Could be used to classify numeric grades into an enumeration of letter grades,
/// or a numeric range of temperatures into strings like “warm” and “cold.”
struct RangeClassifier<Value: Comparable, Classification> {

    typealias Transform = (_ upperLimit: Value, _ value: Value) -> Classification
    typealias Bucket = (upperLimit: Value, transform: Transform)
    typealias Comparator = (Value, Value) -> Bool

    let buckets: [Bucket]
    let outOfBounds: (Value) -> Classification
    let compareFunction: (Value, Value) -> Bool

    ///  Creates a range classifier with the specified options.
    ///
    ///  - parameter buckets:     The buckets to use to classify the input values.
    ///                           Defined as a tuple of an upper bound of the bucket,
    ///                           and a closure that transforms the upper limit of the
    ///                           bucket and the value being classified into a classification.
    ///  - parameter outOfBounds: Transform closure to use for values that don’t fit into
    ///                           any of the explicitly defined buckets. Equivalent to the
    ///                           `default:` case in a `switch` statement.
    ///  - parameter compare:     The comparison function to test a `value` for membership in a `bucket`. You would typically pass `<`.
    ///
    ///  - returns: A range classifier.
    init(buckets: [Bucket], outOfBounds: @escaping (_ value: Value) -> Classification, compare: @escaping Comparator) {
        self.buckets = buckets.sorted { compare($0.upperLimit, $1.upperLimit) }
        self.outOfBounds = outOfBounds
        self.compareFunction = compare
    }

    ///  Classifies a value.
    ///
    ///  - parameter value: The value to classify.
    ///
    ///  - returns: The classification of `value`, according to which bucket it belongs to.
    func classify(_ value: Value) -> Classification {
        for bucket in buckets {
            if compareFunction(value, bucket.upperLimit) {
                return bucket.transform(bucket.upperLimit, value)
            }
        }
        return outOfBounds(value)
    }

}
