//
//  NavigationApp.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 6/8/16.
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
import CoreLocation

enum NavigationApp: String {
    case appleMaps
    case googleMaps
    case blindSquare

    var localizedTitle: String {
        switch self {
        case .appleMaps: return UIStrings.stopDetailLocationNavigateAppNameApple.string
        case .googleMaps: return UIStrings.stopDetailLocationNavigateAppNameGoogle.string
        case .blindSquare: return UIStrings.stopDetailLocationNavigateAppNameBlindsquare.string
        }
    }

    var URLScheme: String {
        switch self {
        case .appleMaps: return "http://"
        case .googleMaps: return "comgooglemaps://"
        case .blindSquare: return "blindsquare://"
        }
    }

    var isInstalled: Bool {
        if let url = URL(string: URLScheme), UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }

    static var all: [NavigationApp] {
        return [
            .appleMaps,
            .googleMaps,
            .blindSquare,
        ]
    }

    static var installed: [NavigationApp] {
        return all.filter { $0.isInstalled }
    }

    func navigateTo(placemark: CLPlacemark) {
        var url: Foundation.URL?

        switch self {
        case .appleMaps:
            if var components = URLComponents(string: "\(URLScheme)maps.apple.com"),
                let addrList = placemark.addressDictionary?["FormattedAddressLines"] as? [String] {
                components.queryItems = [
                    URLQueryItem(name: "daddr", value: addrList.joined(separator: ", ")),
                    URLQueryItem(name: "dirflg", value: "w"),
                ]

                url = components.url
            }
        case .googleMaps:
            if var components = URLComponents(string: URLScheme),
                let addrList = placemark.addressDictionary?["FormattedAddressLines"] as? [String] {
                components.queryItems = [
                    URLQueryItem(name: "daddr", value: addrList.joined(separator: ", ")),
                    URLQueryItem(name: "directionsmode", value: "walking"),
                ]

                url = components.url
            }
        case .blindSquare:
            if var components = URLComponents(string: "\(URLScheme)api/place"),
            let addrList = placemark.addressDictionary?["FormattedAddressLines"] as? [String],
            let location = placemark.location {
                components.queryItems = [
                    URLQueryItem(name: "name", value: addrList.joined(separator: ", ")),
                    URLQueryItem(name: "lat", value: "\(location.coordinate.latitude)"),
                    URLQueryItem(name: "lon", value: "\(location.coordinate.longitude)"),
                ]

                url = components.url
            }

        }

        if let url = url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }

}

extension NavigationApp {

    static var userPreferred: NavigationApp? {
        get {
            if let appString = Defaults.shared.read(UserDefaultsKeys.preferredNavigationApp),
                let app = NavigationApp(rawValue: appString) {
                return app
            }

            return nil
        }
        set {
            if let app = newValue {
                Defaults.shared.write(app.rawValue, forKey: UserDefaultsKeys.preferredNavigationApp)
            } else {
                Defaults.shared.remove(key: UserDefaultsKeys.preferredNavigationApp)
            }
        }
    }

}
