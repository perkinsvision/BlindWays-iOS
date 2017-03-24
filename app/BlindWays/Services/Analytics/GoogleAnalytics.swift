//
//  GoogleAnalytics.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 6/10/16.
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

class GoogleAnalytics {

    static let shared = GoogleAnalytics()

    var tracker: GAITracker {
        return GAI.sharedInstance().defaultTracker
    }

    fileprivate func configure() {
        if let trackerID = AppConstants.Analytics.trackerID {
            let gai = GAI.sharedInstance()
            gai?.trackUncaughtExceptions = false
            _ = gai?.tracker(withTrackingId: trackerID)
            if BuildType.debug.active {
                gai?.logger.logLevel = GAILogLevel.verbose
            }
        }
    }

}

extension GoogleAnalytics: AppLifecycleConfigurable {

    var enabledBuildTypes: [BuildType] {
        return [.internal, .release]
    }

    func onDidLaunch(_ application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        configure()
        guard AppConstants.Analytics.trackerID != nil else {
            return
        }
        UIViewController.globalBehaviors.append(GoogleTrackPageViewBehavior())
    }

}

extension GoogleAnalytics: AnalyticsService {

    private enum CustomDimensions {
        enum VoiceOver {
            static let id: UInt = 1
            static var value: String {
                let voiceOverState: String
                if UIAccessibilityIsVoiceOverRunning() {
                    voiceOverState = "VOICE_OVER_ENABLED"
                } else {
                    voiceOverState = "VOICE_OVER_DISABLED"
                }
                return voiceOverState
            }
        }
    }

    func trackPageView(_ page: String) {
        guard AppConstants.Analytics.trackerID != nil else {
            return
        }
        tracker.set(kGAIScreenName, value: page)
        tracker.set(GAIFields.customDimension(for: CustomDimensions.VoiceOver.id),
                    value: CustomDimensions.VoiceOver.value)
        if let built = GAIDictionaryBuilder.createScreenView().build() as NSDictionary as? [AnyHashable: Any] {
            tracker.send(built)
        }
    }

}

public class GoogleTrackPageViewBehavior: ViewControllerLifecycleBehavior {

    public init() {}
    public func afterAppearing(_ viewController: UIViewController, animated: Bool) {
        guard AppConstants.Analytics.trackerID != nil else {
            return
        }
        if let pageRepresentation = viewController as? AnalyticsPageRepresentation {
            GoogleAnalytics.shared.trackPageRepresentation(pageRepresentation)
        }
    }

}
