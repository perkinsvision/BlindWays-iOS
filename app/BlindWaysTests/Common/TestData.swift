//
//  TestData.swift
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

import Foundation
import RZVinyl
import RZImport
@testable import BlindWays

struct DataFilenames {

    struct Agencies {

        static let list = "agencies"

    }

    struct Stops {

        static let search = "stops_search"
        static let detail = "stop_detail"

    }

}

class TestData {

    class func jsonDictForFileNamed(_ name: String) -> [String: Any] {
        let data = fileDataForName(name)
        let jsonObj = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
        return jsonObj as! [String: Any]
    }

    class func jsonArrayForFileNamed(_ name: String) -> [[String: Any]] {
        let data = fileDataForName(name)
        let jsonObj = try!  JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
        return jsonObj as! [[String: Any]]
    }

    class func fileDataForName(_ name: String, ext: String? = "json") -> Data {
        let bundle = Bundle(for: object_getClass(self))
        let url = bundle.url(forResource: name, withExtension: ext)
        return (try! Data(contentsOf: url!))
    }

}

extension RZImportable where Self: NSObject {

    static func importJSONArrayNamed(_ name: String) -> [Self] {
        let list = TestData.jsonArrayForFileNamed(name)
        return Self.rzi_objects(from: list) as! [Self]
    }

    static func importJSONDictionaryNamed(_ name: String) -> Self {
        let obj = TestData.jsonDictForFileNamed(name)
        return Self.rzi_object(from: obj)
    }

}
