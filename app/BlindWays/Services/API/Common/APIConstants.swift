//
//  APIConstants.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/9/16.
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

struct APIConstants {

    struct Common {

        struct ExternalKeys {
            static let id = "id"
            static let lat = "lat"
            static let lng = "lng"
        }

    }

    struct ClueSets {

        struct ExternalKeys {

            static let helpfulCount = "helpful_count"

        }

    }

    struct Agencies {

        struct ExternalKeys {
            static let name = "name"
            static let nextBusAgencyID = "next_bus_agency_id"

            static let faceUrl = "face_url"
            static let fareUrl = "fare_url"
            static let phone = "phone"
            static let lang = "lang"
            static let timezone = "timezone"
            static let url = "url"
            static let gtfsID = "gtfs_id"
            static let city = "city"
            static let state = "state"
        }

    }

    struct Stops {

        struct ExternalKeys {
            static let location = "location"
            static let routes = "routes"
            static let desc = "description"
            static let latestReportedUserLocation = "latest_reported_user_location"
        }

    }

    struct Routes {

        struct ExternalKeys {
            static let directions = "directions"
        }

    }

}
