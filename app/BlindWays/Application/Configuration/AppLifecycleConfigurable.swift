//
//  AppLifecycleConfigurable.swift
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
import UIKit
import RZVinyl
import Swiftilities
import FBSDKCoreKit

// MARK: Protocol

/// A representation of the current build type, driven by -D compiler flags.
enum BuildType {

    /// Debug build (-D DEBUG)
    case debug
    /// Internal build, configured as release but not for App Store submission (-D RZINTERNAL)
    case `internal`
    /// App store Release build, no flags
    case release

    /// Whether or not this build type is the active build type.
    var active: Bool {
        switch self {
        case .debug:
            #if DEBUG
                return true
            #else
                return false
            #endif
        case .internal:
            #if RZINTERNAL
                return true
            #else
                return false
            #endif
        case .release:
            return !BuildType.debug.active && !BuildType.internal.active
        }
    }

}

/**
 *  Objects conforming to this protocol provide some sort of configurable behavior intended for execution
 *  on app launch.
 */
protocol AppLifecycleConfigurable {

    /// The build types to which the conforming instance applies.
    var enabledBuildTypes: [BuildType] { get }

    /**
     Invoked on UIApplication.applicationDidFinishLaunching to give the conforming instance a chance to execute configuration.

     - parameter application:   The application
     - parameter launchOptions: Optional launch options
     */
    func onDidLaunch(_ application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?)

    /**
     Invoked on UIApplication.applicationDidBecomeActive to give the conforming instance a chance to execute configuration.

     - parameter application: The application
     */
    func onDidBecomeActive(_ application: UIApplication)
}

extension AppLifecycleConfigurable {

    var enabledBuildTypes: [BuildType] {
        return [.debug, .internal, .release]
    }

    func onDidLaunch(_ application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        // Conformers can override to provide customization
    }

    func onDidBecomeActive(_ application: UIApplication) {
        // Conformers can override to provide customization
    }

    /// Whether or not this configurable instance is enabled for the current build type.
    var isEnabled: Bool {
        for buildType in self.enabledBuildTypes {
            if buildType.active {
                return true
            }
        }
        return false
    }

}

// MARK: Logging

struct LoggingConfiguration: AppLifecycleConfigurable {

    var enabledBuildTypes: [BuildType] {
        return [.debug, .internal]
    }

    func onDidLaunch(_ application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        Log.logLevel = .info
    }

}

// MARK: Facebook

struct FacebookConfiguration: AppLifecycleConfigurable {

    var enabledBuildTypes: [BuildType] {
        return [.internal, .release]
    }

    func onDidBecomeActive(_ application: UIApplication) {
        // PLACEHOLDER - To enable Facebook integration, you will need to add
        // a valid key for "FacebookAppID" and "FacebookDisplayName"
        // for more info check out: https://developers.facebook.com/docs/ios/getting-started
        FBSDKAppEvents.activateApp()
    }

}
