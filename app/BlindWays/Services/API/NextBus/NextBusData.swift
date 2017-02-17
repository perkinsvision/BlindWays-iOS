//
//  NextBusData.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/30/16.
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
import SWXMLHash

struct NextBusPrediction {
    let route: String
    let destination: String

    let arrivalDate: Date

    /// The number of minutes until the bus arrives
    let minutes: Int

    /// The total number of seconds until the bus arrives. This is _not_
    /// the remainder after the minutes have been subtracted out. Rather,
    /// it is the entire time until the bus arrives, expressed in seconds.
    let seconds: Int

    static func predictionsFromXML(data: Data) -> [NextBusPrediction] {
        var results = [NextBusPrediction]()
        let xml = SWXMLHash.parse(data)
        for prediction in xml["body"]["predictions"] {
            guard let routeTitle = prediction.element?.allAttributes["routeTitle"]?.text else { continue }

            for direction in prediction["direction"] {
                guard let directionTitle = direction.element?.allAttributes["title"]?.text else { continue }

                for prediction in direction["prediction"] {
                    if let epochTimeString = prediction.element?.allAttributes["epochTime"]?.text, let epochTimeMilliseconds = Double(epochTimeString),
                        let minutesString = prediction.element?.allAttributes["minutes"]?.text, let minutes = Int(minutesString),
                        let secondsString = prediction.element?.allAttributes["seconds"]?.text, let seconds = Int(secondsString) {
                        // The value in the API is documented as seconds, but it actually represents milliseconds.
                        // Documentation here: https://www.nextbus.com/xmlFeedDocs/NextBusXMLFeed.pdf
                        let epochTimeSeconds = epochTimeMilliseconds / 1000.0
                        results.append(NextBusPrediction(route: routeTitle,
                            destination: directionTitle,
                            arrivalDate: Date(timeIntervalSince1970: epochTimeSeconds),
                            minutes: minutes,
                            seconds: seconds))
                    }
                }
            }

        }

        return results
    }

}
