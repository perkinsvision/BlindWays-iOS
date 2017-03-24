//
//  AppConstants.swift
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

struct AppConstants {

    struct APIReadToken {
        // PLACEHOLDER - These need to be api access tokens for your own server
        static let dev: String?     = nil
        static let staging: String? = nil
        static let prod: String?    = nil
    }

    struct Emails {
        // PLACEHOLDER - This needs to be set to a real email address
        static let reportProblem = "problem@placholder-email"
    }

    struct Analytics {
        // PLACEHOLDER - To enable google analytics, you must supply your google analytics key
        static let trackerID: String? = nil
    }

}
