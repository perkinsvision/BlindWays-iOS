//
//  StringTest.swift
//  BlindWaysTests
//
//  Created by Zev Eisenberg on 7/1/16.
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

class StringTest: XCTestCase {

    func testVoiceOverHinting() {
        let en_US = Locale(identifier: "en_US")

        let tests = [
            (input: "Mt. Auburn St. opp Coolidge Ave.", controlOutput: " Mount Auburn St. opposite Coolidge Avenue "),
            (input: "Ave Maria St. opp Coolidge Ave.", controlOutput: "Ave Maria St. opposite Coolidge Avenue "),
            (input: "Robert Oppenheimer Ave. opp Coolidge St.", controlOutput: "Robert Oppenheimer Avenue opposite Coolidge St."),
            (input: "Theo Glynn Way @ Newmarket Sq", controlOutput: "Theo Glynn Way @ Newmarket Square "),
            (input: "Circuit Dr @ Glen Ln", controlOutput: "Circuit Drive @ Glen Lane "),
            (input: "Western Ave @ N Harvard St", controlOutput: "Western Avenue @ North Harvard St"),
            (input: "W Second St opp W Third St", controlOutput: " West Second St opposite West Third St"),
            (input: "American Legion Hwy @ Beach St - Bell Circle", controlOutput: "American Legion Highway @ Beach St - Bell Circle"),
            (input: "Woburn St @ Lowell St - Reading Sq", controlOutput: "Woburn St @ Lowell St - Reading Square "),
            (input: "361 Washington St @ Aldaen Pk", controlOutput: "361 Washington St @ Aldaen Park "),
            (input: "B St @ W 5th St", controlOutput: "B St @ West 5th St"),
            (input: "Pleasant St @ Stone Pl", controlOutput: "Pleasant St @ Stone Place "),
            (input: "Bunker Hill St @ Clarken Ct", controlOutput: "Bunker Hill St @ Clarken Court "),
            (input: "Cambridge St @ Government Ctr Sta", controlOutput: "Cambridge St @ Government Center Station "),
            (input: "Malden Ctr Sta East Busway Bay", controlOutput: "Malden Center Station East Busway Bay"),
        ]

        for (input, controlOutput) in tests {
            XCTAssertEqual(String.makeLocationVoiceOverPronounceable(input, locale: en_US), controlOutput)
        }
    }

    func testVoiceOverHintingInOtherEnglishDialects() {
        let en_GB = Locale(identifier: "en_GB")

        let gbTest = "Mt. Auburn St. opp Coolidge Ave."
        XCTAssertEqual(String.makeLocationVoiceOverPronounceable(gbTest, locale: en_GB), " Mount Auburn St. opposite Coolidge Avenue ")

        let en_CA = Locale(identifier: "en_CA")
        let caTest = "Mt. Auburn St. opp Coolidge Ave."
        XCTAssertEqual(String.makeLocationVoiceOverPronounceable(caTest, locale: en_CA), " Mount Auburn St. opposite Coolidge Avenue ")
    }

    func testVoiceOverHintingInNonEnglish() {
        let fr_FR = Locale(identifier: "fr_FR")
        let frTest = "Mt. Auburn St. opp Coolidge Ave."
        XCTAssertEqual(String.makeLocationVoiceOverPronounceable(frTest, locale: fr_FR), "Mt. Auburn St. opp Coolidge Ave.")
    }

    func testSubstringOfAtMostNCharacters() {
        let string = "asdf"
        XCTAssertEqual(string.truncatedSubstring(maxLength: 0), "…")
        XCTAssertEqual(string.truncatedSubstring(maxLength: 1), "a…")
        XCTAssertEqual(string.truncatedSubstring(maxLength: 2), "as…")
        XCTAssertEqual(string.truncatedSubstring(maxLength: 3), "asd…")
        XCTAssertEqual(string.truncatedSubstring(maxLength: 4), "asdf")
        XCTAssertEqual(string.truncatedSubstring(maxLength: 5), "asdf")
    }

}
