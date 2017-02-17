//
//  GoogleConversionTracking.swift
//  BlindWays
//
//  Created by Matthew Buckley on 10/19/16.
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

class GoogleConversionTracking {

    static let shared = GoogleConversionTracking()

    fileprivate let conversionID = "1064878398"
    fileprivate let label = "0GtJCNTv_2oQvoLj-wM"
    fileprivate let value = "0.00"

    fileprivate func configure() {
        ACTAutomatedUsageTracker.enableAutomatedUsageReporting(withConversionID: conversionID)
        ACTConversionReporter.report(withConversionID: conversionID, label: label, value: value, isRepeatable: false)
    }

}

extension GoogleConversionTracking: AppLifecycleConfigurable {

    var enabledBuildTypes: [BuildType] {
        return [.internal, .release]
    }

    func onDidLaunch(_ application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        configure()
        UIViewController.globalBehaviors.append(GoogleTrackPageViewBehavior())
    }

}
