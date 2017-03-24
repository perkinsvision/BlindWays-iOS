//
//  LocationViewModel.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 4/5/16.
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

@objc
protocol LocationInfoActions {

    func getDirectionsTapped()
    func showMapTapped()

}

struct LocationViewModel: InfoItem, TintableItem {

    enum Accuracy {
        case unknown
        case bad
        case fair
        case good

        init(location: CLLocation) {
            let result = RangeClassifier<CLLocationAccuracy, Accuracy>(
                buckets: [
                    (upperLimit: 10, transform: { _ in return .good }),
                    (upperLimit: 30, transform: { _ in return .fair }),
                    (upperLimit: Double.infinity, transform: { _ in return .bad }),
                ],
                outOfBounds: { _ in return .unknown },
                compare: <).classify(location.horizontalAccuracy)
            self = result
        }

        var localizedTitle: String {
            switch self {
            case .bad: return UIStrings.stopDetailLocationAccuracyBad.string
            case .fair: return UIStrings.stopDetailLocationAccuracyFair.string
            case .good: return UIStrings.stopDetailLocationAccuracyGood.string
            default: return ""
            }
        }

        var titleColor: UIColor {
            switch self {
            case .bad: return Colors.Common.darkOrange
            default: return Colors.Common.black
            }
        }

        var iconColor: UIColor {
            switch self {
            case .bad: return Colors.Common.darkOrange
            default: return Colors.Common.windowsBlue
            }
        }

        var iconImage: UIImage {
            return Asset.icnLocation.image
        }

    }

    enum Distance {
        case unknown
        case meters(CLLocationDistance)

        init(userLocation: CLLocation, stopLocation: CLLocation, locale: Locale = Locale.current) {
            let distanceMeters = userLocation.distance(from: stopLocation)
            self = .meters(distanceMeters)
        }

        func localizedTitle(locale: Locale = Locale.current) -> String {
            switch self {
            case .meters(let meters):
                return DistanceFormatter.formatDistanceIntoBuckets(meters, locale: locale)
            case .unknown:
                return ""
            }
        }

        func isFar(locale: Locale = Locale.current) -> Bool {
            switch self {
            case .meters(let meters):
                return meters > Distance.farMax(locale: locale)
            case .unknown:
                return false
            }
        }

    }

    let accuracy: Accuracy
    let distance: Distance
    let localizedTitle: String
    let localizedSubtitle: String?
    let localizedSupplementalText: String? = nil
    let hasChildren: Bool
    let titleColor: UIColor
    let iconColor: UIColor
    let iconImage: UIImage
    let iconLabel: String? = UIStrings.stopDetailAccessibilityLocationIconLabel.string
    let accessibilityHint: String? = nil

    var userLocation: CLLocation?
    var stopLocation: CLLocation?

    init(userLocation: CLLocation, stopLocation: CLLocation) {
        self.accuracy = Accuracy(location: userLocation)
        self.distance = Distance(userLocation: userLocation, stopLocation: stopLocation)
        self.localizedTitle = distance.localizedTitle()
        self.localizedSubtitle = distance.isFar(locale: Locale.current) ? UIStrings.stopDetailLocationNavigateSubtitle.string : accuracy.localizedTitle
        self.titleColor = accuracy.titleColor
        self.iconColor = accuracy.iconColor
        self.iconImage = accuracy.iconImage
        self.hasChildren = true
        self.userLocation = userLocation
        self.stopLocation = stopLocation
    }

    init(localizedTitle: String, localizedSubtitle: String, showDisclosureIndicator: Bool, titleColor: UIColor = Colors.Common.black, iconColor: UIColor = Colors.Common.windowsBlue, iconImage: UIImage = Asset.icnLocation.image) {
        self.accuracy = .unknown
        self.distance = .unknown
        self.localizedTitle = localizedTitle
        self.localizedSubtitle = localizedSubtitle
        self.titleColor = titleColor
        self.iconColor = iconColor
        self.iconImage = iconImage
        self.hasChildren = showDisclosureIndicator
    }

}

extension LocationViewModel: AccessiblyActionableItem {

    var accessibilityActions: [(name: UIStrings, selector: Selector)]? {

        switch GeoLocator.authorizationStatus {
        case .yes:
            return [
                (name: UIStrings.stopDetailLocationNavigateSubtitle, selector: #selector(LocationInfoActions.getDirectionsTapped)),
                (name: UIStrings.stopDetailLocationShowMapSubtitle, selector: #selector(LocationInfoActions.showMapTapped)),
            ]
        default:
            return nil
        }
    }

}

private extension LocationViewModel.Distance {
    static func farMax(locale: Locale) -> Double {
        if locale.isMetric {
            return LocationConstants.metersPerKilometer
        } else {
            return LocationConstants.metersPerMile
        }
    }
}

private struct DistanceFormatter {

    fileprivate static let distanceFormatter = NumberFormatter()

    fileprivate static func format(_ number: Double, decimalPoint: Bool, locale: Locale) -> String {
        var result: String!
        DistanceFormatter.formatterQueue.sync {
            DistanceFormatter.distanceFormatter.locale = locale
            DistanceFormatter.distanceFormatter.minimumFractionDigits = decimalPoint ? 1 : 0
            DistanceFormatter.distanceFormatter.maximumFractionDigits = decimalPoint ? 1 : 0
            DistanceFormatter.distanceFormatter.minimumIntegerDigits = 1
            result = DistanceFormatter.distanceFormatter.string(from: NSNumber(value: number))
        }
        return result
    }

    fileprivate static let formatterQueue: DispatchQueue = DispatchQueue(label: "formatterQueue", attributes: [])

    static func formatDistanceIntoBuckets(_ meters: CLLocationDistance, locale: Locale) -> String {
        assert(meters >= 0)
        if !locale.isMetric {
            let feet = meters / LocationConstants.metersPerFoot
            let tenMilesInFeet = 10 * LocationConstants.feetPerMile
            let miles = feet / LocationConstants.feetPerMile

            let feetTransform = { (upperLimit: Double, value: Double) in
                UIStrings.stopDetailLocationWithinFt(Int(upperLimit)).string
            }

            let buckets = [
                (upperLimit: 15, transform: { upperLimit, b in return UIStrings.stopDetailLocationWithinFt(Int(upperLimit)).string }),
                (upperLimit: 50, transform: feetTransform),
                (upperLimit: 100, transform: feetTransform),
                (upperLimit: 200, transform: feetTransform),
                (upperLimit: 500, transform: feetTransform),
                (upperLimit: tenMilesInFeet, transform: { _ in
                    let formatted = DistanceFormatter.format(miles, decimalPoint: true, locale: locale)
                    return UIStrings.stopDetailLocationMiAway(formatted).string
                }),
                ]
            let outOfBoundsFormatter: (Double) -> String = { _ in
                let formatted = DistanceFormatter.format(miles, decimalPoint: false, locale: locale)
                return UIStrings.stopDetailLocationMiAway(formatted).string
            }
            let feetClassifier = RangeClassifier(buckets: buckets, outOfBounds: outOfBoundsFormatter, compare: <)
            return feetClassifier.classify(feet)
        } else {
            let tenKilometersInMeters: CLLocationDistance = 10 * LocationConstants.metersPerKilometer
            let kilometers = meters / LocationConstants.metersPerKilometer

            let metersTransform = { (upperLimit: Double, value: Double) in
                UIStrings.stopDetailLocationWithinM(Int(upperLimit)).string
            }

            let buckets = [
                (upperLimit: 5, transform: metersTransform),
                (upperLimit: 15, transform: metersTransform),
                (upperLimit: 30, transform: metersTransform),
                (upperLimit: 60, transform: metersTransform),
                (upperLimit: tenKilometersInMeters, transform: { _ in
                    let formatted = DistanceFormatter.format(kilometers, decimalPoint: true, locale: locale)
                    return UIStrings.stopDetailLocationKmAway(formatted).string
                }),
                ]
            let outOfBoundsFormatter: (Double) -> String = { _ in
                    let formatted = DistanceFormatter.format(kilometers, decimalPoint: false, locale: locale)
                    return UIStrings.stopDetailLocationKmAway(formatted).string
            }
            let metersClassifier = RangeClassifier(buckets: buckets, outOfBounds: outOfBoundsFormatter, compare: <)
            return metersClassifier.classify(meters)
        }
    }

}
