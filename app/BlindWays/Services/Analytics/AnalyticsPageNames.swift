//
//  AnalyticsPageNames.swift
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

import UIKit

extension StopsListViewController: AnalyticsPageRepresentation {

    var analyticsPageName: String {
        return "StopsList_\(viewModel.analyticsPageName)"
    }

}

extension StopDetailViewController: AnalyticsPageRepresentation {

    var analyticsPageName: String {
        return "StopDetail"
    }

}

extension BusArrivalsViewController: AnalyticsPageRepresentation {

    var analyticsPageName: String {
        return "BusArrivals"
    }

}

extension CaptureStopLocationViewController: AnalyticsPageRepresentation {

    var analyticsPageName: String {
        return "CaptureStopLocationPrompt"
    }

}

extension CaptureLocationCardViewController: AnalyticsPageRepresentation {

    var analyticsPageName: String {
        return "CaptureStopLocation"
    }

}

extension EditCluesViewController: AnalyticsPageRepresentation {

    var analyticsPageName: String {
        return "EditClues"
    }

}

extension SettingsViewController: AnalyticsPageRepresentation {

    var analyticsPageName: String {
        return "Settings"
    }

}

extension OnboardingViewController: AnalyticsPageRepresentation {

    var analyticsPageName: String {
        return "Onboarding"
    }

}

extension AuthViewController: AnalyticsPageRepresentation {

    var analyticsPageName: String {
        return "Auth_\(viewModel.analyticsName)"
    }

}

extension RouteSearchViewController: AnalyticsPageRepresentation {

    var analyticsPageName: String {
        return "SearchRoutes"
    }

}
