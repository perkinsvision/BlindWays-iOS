//
//  GeoLocator.swift
//  BlindWays
//
//  Created by John Watson on 1/19/16.
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
import Foundation

/// A `GeoLocator` manages access to a `CLLocationManager` instance and acts as
/// its delegate.
public class GeoLocator: NSObject {

    /// A closure that is called with the device's most recent location.
    public typealias LocationUpdateHandler = (CLLocation) -> Void

    /// A closure that is called with the device's most recent heading.
    public typealias HeadingUpdateHandler = (CLHeading) -> Void

    /// A closure that logs messages.
    public typealias LogHandler = (_ message: () -> String, _ level: LogLevel, _ file: StaticString, _ line: UInt) -> Void

    /**
     The `GeoLocator`'s mode of operation.

     - OneShot:    Update the device's location only when asked.
     - Continuous: Continuously monitor the device's location.
     */
    public enum LocationMonitoringMode {
        case oneShot
        case continuous
    }

    /**
     The `GeoLocator`'s authorization status.

     - Unknown: It is unknown whether the user has granted access or not.
     - Yes:     The user has granted access to their location.
     - No:      The user has denied access to their location.
     */
    public enum AuthorizationStatus {
        case unknown
        case yes
        case no
    }

    /**
     Log levels used by the `GeoLocator`.

     - Error:   Error-level, possibly unrecoverable messages
     - Warning: Important messages
     - Info:    Informative messages
     - Debug:   Debug messages
     - Verbose: Everything
     */
    public enum LogLevel: Int {
        case error
        case warning
        case info
        case debug
        case verbose
    }

    /// Return the application's authorization status for location services.
    public class var authorizationStatus: AuthorizationStatus {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            return .yes

        case .denied, .restricted:
            return .no

        case .notDetermined:
            return .unknown
        }
    }

    /// The location manager instance. Use this to customize location
    /// monitoring behavior.
    public let manager = CLLocationManager()

    /// The `GeoLocator`'s location monitoring mode.
    public let locationMode: LocationMonitoringMode

    /// The device's location from the most recent update.
    public fileprivate(set) var location: CLLocation

    /// The device's heading from the most recent update.
    public fileprivate(set) var heading: CLHeading?

    /// The maximum age (in seconds) a location update may be before it is
    /// discarded. Defaults to 15 seconds.
    public var maxLocationAge = TimeInterval(15.0)

    /// The maximum age (in seconds) a heading update may be before it is
    /// discarded. Defaults to 1 second.
    public var maxHeadingAge = TimeInterval(1.0)

    /// Handler used to log framework messages.
    public var logHandler: LogHandler?

    fileprivate var locationUpdateHandler: LocationUpdateHandler?
    fileprivate var headingUpdateHandler: HeadingUpdateHandler?
    fileprivate var locationActive = false
    fileprivate var headingActive = false
    fileprivate var waitingForAuthorization = false

    public var isActive: Bool {
        return locationActive || headingActive
    }

    /**
     Initialize a `GeoLocator` instance with the given monitoring mode.

     - parameter mode: The monitoring mode to use.
     */
    public init(locationMode: LocationMonitoringMode = .oneShot) {
        self.locationMode = locationMode

        // Start with an invalid location.
        location = CLLocation(
            latitude: kCLLocationCoordinate2DInvalid.latitude,
            longitude: kCLLocationCoordinate2DInvalid.longitude
        )

        super.init()

        manager.delegate = self
    }

}

// MARK: - Public

extension GeoLocator {

    /**
     Request a one-shot location update.

     - parameter handler: A closure that will be executed when the device's
     location is updated.
     */
    public func requestLocationUpdate(_ handler: LocationUpdateHandler?) {
        guard locationMode == .oneShot else {
            handler?(location)
            return
        }

        let status = CLLocationManager.authorizationStatus()
        guard status != .restricted && status != .denied else {
            handler?(location)
            return
        }

        guard !locationActive else {
            return
        }

        locationUpdateHandler = handler

        if GeoLocator.authorizationStatus == .yes {
            locationActive = true
            manager.requestLocation()
        } else {
            waitingForAuthorization = true
            manager.requestWhenInUseAuthorization()
        }
    }

    /**
     Start continuously monitoring the device's location.

     - parameter handler: A closure that will be executed every time the
                          device's location updates.
     */
    public func startMonitoringLocation(_ handler: LocationUpdateHandler?) {
        guard locationMode == .continuous else {
            handler?(location)
            return
        }

        let status = CLLocationManager.authorizationStatus()
        guard status != .restricted && status != .denied else {
            handler?(location)
            return
        }

        guard !locationActive else {
            return
        }

        locationUpdateHandler = handler

        if GeoLocator.authorizationStatus == .yes {
            locationActive = true
            manager.startUpdatingLocation()
        } else {
            waitingForAuthorization = true
            manager.requestWhenInUseAuthorization()
        }

    }

    /**
     Start continuously monitoring the device's heading.

     - parameter handler: A closure that will be executed every time the
     device's heading updates.
     */
    public func startMonitoringHeading(_ handler: HeadingUpdateHandler?) {
        let status = CLLocationManager.authorizationStatus()
        guard status != .restricted && status != .denied else {
            if let heading = heading {
                handler?(heading)
            }
            return
        }

        guard !headingActive else {
            return
        }

        headingUpdateHandler = handler

        if GeoLocator.authorizationStatus == .yes {
            headingActive = true
            manager.startUpdatingHeading()
        } else {
            waitingForAuthorization = true
            manager.requestWhenInUseAuthorization()
        }

    }

    /**
     Stop continously monitoring the device's location.
     */
    public func stopMonitoringLocation() {
        if GeoLocator.authorizationStatus == .yes && locationMode == .continuous {
            manager.stopUpdatingLocation()
            locationUpdateHandler = nil
            locationActive = false
        }
    }

    /**
     Stop continously monitoring the device's heading.
     */
    public func stopMonitoringHeading() {
        if GeoLocator.authorizationStatus == .yes {
            manager.stopUpdatingHeading()
            headingUpdateHandler = nil
            headingActive = false
        }
    }

    /**
     Stop continously monitoring the device's location and heading.
     */
    public func stopMonitoringLocationAndHeading() {
        stopMonitoringLocation()
        stopMonitoringHeading()
    }

}

// MARK: - Location Manager Delegate

extension GeoLocator: CLLocationManagerDelegate {

    // MARK: Responding to Location Events

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            assertionFailure("Must have at least one valid location!")
            return
        }

        log({ "location updated: \(newLocation.coordinate)" }, level: .verbose)

        let locationAge = abs(newLocation.timestamp.timeIntervalSinceNow)
        if locationMode == .continuous && locationAge > maxLocationAge || newLocation.horizontalAccuracy < 0.0 {
            log({ "ignoring old location" }, level: .info)
            return
        }

        location = newLocation

        switch locationMode {
        case .oneShot:
            locationUpdateHandler?(location)
            locationActive = false
            locationUpdateHandler = nil

        case .continuous:
            locationUpdateHandler?(location)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        log({ "heading updated: \(newHeading)" }, level: .verbose)

        let headingAge = abs(newHeading.timestamp.timeIntervalSinceNow)
        if headingAge > maxHeadingAge || newHeading.headingAccuracy < 0.0 {
            log({ "ignoring old heading" }, level: .info)
            return
        }

        heading = newHeading

        if let heading = heading {
            headingUpdateHandler?(heading)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let code = CLError.Code(rawValue: (error as NSError).code), (error as NSError).domain == kCLErrorDomain {
            switch code {
            case .locationUnknown:
                log({"Unknown location"}, level: .error)

            case .denied:
                log({"User has denied location access"}, level: .error)
                stopMonitoringLocationAndHeading()

            default:
                break
            }
        }

        if locationMode == .oneShot {
            locationUpdateHandler?(location)
            if let heading = heading {
                headingUpdateHandler?(heading)
            }
            locationUpdateHandler = nil
            headingUpdateHandler = nil
            locationActive = false
            headingActive = false
        }
    }

    // MARK: Responding to Authorization Changes

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        log({ "authorization status changed to \(status)"}, level: .verbose)

        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            if waitingForAuthorization {
                waitingForAuthorization = false
                switch locationMode {
                case .oneShot:
                    requestLocationUpdate(locationUpdateHandler)
                case .continuous:
                    startMonitoringLocation(locationUpdateHandler)
                    startMonitoringHeading(headingUpdateHandler)
                }
            }

        case .restricted,
             .denied:
            if locationMode == .continuous {
                stopMonitoringLocationAndHeading()
            }

            location = CLLocation(
                latitude: kCLLocationCoordinate2DInvalid.latitude,
                longitude: kCLLocationCoordinate2DInvalid.longitude
            )

            if locationActive || headingActive || waitingForAuthorization {
                locationActive = false
                headingActive = false
                waitingForAuthorization = false
                locationUpdateHandler?(location)
                if let heading = heading {
                    headingUpdateHandler?(heading)
                }
            }

        case .notDetermined:
            break
        }
    }

}

private extension GeoLocator {

    func log(_ message: () -> String, level: LogLevel, file: StaticString = #file, line: UInt = #line) {
        logHandler?(message, level, file, line)
    }

}
