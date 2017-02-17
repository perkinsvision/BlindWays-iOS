//
//  AppDelegate.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 1/25/16.
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
import CoreLocation
import Swiftilities
import RZVinyl
import AVFoundation

@objc
protocol CommonActions {
    func launchAppSettings()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let bundleIdentifier = Bundle.main.bundleIdentifier!

    static func reverseDomain(_ suffix: String) -> String {
        return bundleIdentifier + "." + suffix
    }

    struct NotificationName {

        static let registeredUserNotificationSettings = AppDelegate.reverseDomain("notification.registeredUserNotificationSettings")

    }

    static var shared: AppDelegate {
        return Utility.forceCast(UIApplication.shared.delegate, asType: AppDelegate.self)
    }

    var window: UIWindow?

    let configurations: [AppLifecycleConfigurable] = [
        LoggingConfiguration(),
        CoreDataConfiguration(),
        Appearance.shared,
        GoogleAnalytics.shared,
        GoogleConversionTracking.shared,
        FirebaseService.shared,
        FacebookConfiguration(),
    ]

    let apiClient: APIClient = {
        #if DEFAULT_ENV_DEV
            return APIClient(configuration: TokenConfiguration(env: .dev))
        #elseif DEFAULT_ENV_STAGE
            return APIClient(configuration: TokenConfiguration(env: .staging))
        #else
            return APIClient(configuration: TokenConfiguration(env: .production))
        #endif
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        UIViewController.enableLifecyleBehavior()

        for config in configurations where config.isEnabled {
            config.onDidLaunch(application, launchOptions: launchOptions)
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white

        configureMainView()

        window?.makeKeyAndVisible()

        // If the user is playing audio, don't interrupt it with the silent onboarding video
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch {
            Log.error("Error setting audio session category to Ambient: \(error)")
        }

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        for config in configurations where config.isEnabled {
            config.onDidBecomeActive(application)
        }

        apiClient.clueTypes { (result) in
            if let value = result.value {
                let config = RemoteConfig.defaultConfig()
                config?.landmarkClueTypes = value.landmark
                config?.busStopClueTypes = value.busStopSign
            }
        }
    }

    // MARK: App Settings

    func launchAppSettings() {
        if let url = URL(string: UIApplicationOpenSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }

    // MARK: Notifications

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        NotificationCenter.default.post(name: Notification.Name(AppDelegate.NotificationName.registeredUserNotificationSettings), object: nil)
    }

    // MARK: View

    func configureMainView() {
        let signedIn = apiClient.configuration.authToken != nil

        if signedIn && Defaults.shared.read(UserDefaultsKeys.hasSeenOnboarding) {
            presentMainAnimated(false)
        } else {
            presentOnboardingAnimated(false)
        }
    }

    func presentMainAnimated(_ animated: Bool) {
        if let window = window {
            window.rootViewController?.dismiss(animated: false, completion: nil)
            let geo = GeoLocator(locationMode: .oneShot)
            geo.manager.desiredAccuracy = kCLLocationAccuracyHundredMeters

            let nearbyViewModel = NearbyStopsViewModel(client: apiClient, geo: geo)
            let savedViewModel = SavedStopsViewModel(client: apiClient)
            let mainViewModel = MainViewModel(client: apiClient, listViewModels: [nearbyViewModel, savedViewModel])

            let mainVC = MainViewController(viewModel: mainViewModel)
            let nav = UINavigationController(rootViewController: mainVC)
            window.setRootViewController(nav, animated: animated, completion: {})
        }
    }

    func presentOnboardingAnimated(_ animated: Bool) {
        window?.rootViewController?.dismiss(animated: false, completion: nil)
        if let window = window {
            let onboardingVC = OnboardingViewController(client: apiClient)
            window.setRootViewController(onboardingVC, animated: animated, completion: {})
        }
    }

    // MARK: Extensions

    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplicationExtensionPointIdentifier) -> Bool {
        // Disable custom keyboards, because they cause problems for keyboard avoidance
        // in the case of text views embedded in scroll views. This catch-all solution
        // is more extreme than we would prefer, but there's no way to prevent custom
        // keyboards for individual non-secure text fields.
        if extensionPointIdentifier == UIApplicationExtensionPointIdentifier.keyboard {
            return false
        }

        return true
    }

}
