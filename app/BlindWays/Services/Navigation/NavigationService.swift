//
//  NavigationService.swift
//  BlindWays
//
//  Created by Zev Eisenberg on 9/29/16.
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

import CoreLocation

enum NavigationService {

    static func requestNavigation(to location: CLLocation, placeName: String, inViewController viewController: UIViewController) {
        if let preferredApp = NavigationApp.userPreferred {
            if preferredApp.isInstalled {
                navigate(to: location, app: preferredApp)
            } else {
                // If the user has uninstalled their preferred app, remove their setting and
                // fall back to the no pref behavior.
                NavigationApp.userPreferred = nil
                promptAndNavigate(to: location, placeName: placeName, inViewController: viewController)
            }
        } else {
            promptAndNavigate(to: location, placeName: placeName, inViewController: viewController)
        }
    }

}

private extension NavigationService {

    static func navigate(to location: CLLocation, app: NavigationApp) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { (placemarks, _) in
            if let placemarks = placemarks, placemarks.count > 0 {
                app.navigateTo(placemark: placemarks[0])
            }
        }
    }

    static func promptAndNavigate(to location: CLLocation, placeName: String, inViewController viewController: UIViewController) {
        if NavigationApp.installed.count == 1 {
            NavigationService.navigate(to: location, app: NavigationApp.installed[0])
        } else {
            let alert = UIAlertController(title: nil,
                                          message: UIStrings.stopDetailLocationNavigatePromptSubtitle(placeName).string,
                                          preferredStyle: .actionSheet)

            for app in NavigationApp.installed {
                alert.addAction(UIAlertAction(title: app.localizedTitle, style: .default) { _ in
                    NavigationService.navigate(to: location, app: app)
                    NavigationApp.userPreferred = app
                    })
            }

            alert.addAction(UIAlertAction(title: UIStrings.commonCancel.string, style: .cancel, handler: nil))

            viewController.present(alert, animated: true, completion: nil)
        }
    }

}
