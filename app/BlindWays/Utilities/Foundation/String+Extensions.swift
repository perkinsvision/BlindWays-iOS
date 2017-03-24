//
//  String+Extensions.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 5/27/16.
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

extension String {

    var rz_trimmed: String {
        return trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        )
    }

    var rz_sentenceTerminated: String {
        if self.characters.last != "." {
            return self + ". "
        } else {
            return self
        }
    }

    static func makeLocationVoiceOverPronounceable(_ input: String, locale: Locale = Locale.current) -> String {
        let identifier = locale.identifier
        if identifier.hasPrefix("en_") {
            let replacements = [
                ("\\sopp\\.?\\s", " opposite "),
                ("(^|\\s)mt\\.?\\s", " Mount "),
                ("\\save\\.?($|\\s)", " Avenue "),
                ("\\ssq\\.?($|\\s)", " Square "),
                ("\\sln\\.?($|\\s)", " Lane "),
                ("(^|\\s)n\\.?\\s", " North "),
                ("(^|\\s)e\\.?\\s", " East "),
                ("(^|\\s)s\\.?\\s", " South "),
                ("(^|\\s)w\\.?\\s", " West "),
                ("\\shwy\\.?($|\\s)", " Highway "),
                ("\\spk\\.?($|\\s)", " Park "),
                ("\\spl\\.?($|\\s)", " Place "),
                ("\\sct\\.?($|\\s)", " Court "),
                ("\\sctr\\.?($|\\s)", " Center "),
                ("\\ssta\\.?($|\\s)", " Station "),
                ("\\sdr\\.?($|\\s)", " Drive "),
            ]

            var output = input
            for (regexString, replacement) in replacements {
                do {
                    let regularExpression = try NSRegularExpression(pattern: regexString, options: .caseInsensitive)
                    output = regularExpression.stringByReplacingMatches(in: output, options: [], range: NSRange(location: 0, length: output.characters.count), withTemplate: replacement)
                } catch(let error) {
                    Log.error("invalid regular expression string: '\(regexString)', error: \(error)")
                    preconditionFailure()
                }
            }
            return output
        } else {
            return input
        }
    }

    ///  Truncates a string to the given number of characters. If truncation was necessary, an ellipsis (…)
    ///  is appended. The ellipsis does not count toward the given length, so requesting a substring
    ///  of 10 characters will result in a string that is a maximum of 11 characters long.
    ///
    ///  - parameter characterCount: The maximum characters from the original string to include.
    ///
    ///  - returns: The truncated string, with an appended ellipsis if necessary.
    func truncatedSubstring(maxLength: Int) -> String {
        assert(maxLength >= 0)
        if characters.count <= maxLength {
            return self
        } else {
            return UIStrings.commonTruncation(self.substring(to: characters.index(startIndex, offsetBy: maxLength))).string
        }
    }

}
