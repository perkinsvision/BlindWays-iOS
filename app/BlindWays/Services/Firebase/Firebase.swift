//
//  Firebase.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 7/21/16.
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
import Firebase
import FirebaseMessaging
import Swiftilities

class FirebaseService {

    static let shared = FirebaseService()

    func configure() {
        let envString = BuildType.release.active ? Constants.optionsIdentifierProd : Constants.optionsIdentifierDev
        guard let options = FirebaseService.optionsForEnv(envString) else {
            Log.error("Options not found for env: \(envString)")
            return
        }

        FIRApp.configure(with: options)

        registerForAuthNotifications()
    }

    static func registerForPush() {
        let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        Defaults.shared.write(true, forKey: UserDefaultsKeys.hasSeenNotificationPrompt)
    }

}

private extension FirebaseService {

    struct Constants {

        static let optionsIdentifierDev =   "Dev"
        static let optionsIdentifierProd =  "Prod"

        static let topicFormat = "/topics/user_%@"

    }

    static func optionsForEnv(_ env: String) -> FIROptions? {
        // PLACEHOLDER - to enable Firebase, you'll need to download config files from
        // https://firebase.google.com/docs/ios/setup and add them to the project.
        // The app expects a "GoogleService-Info-Dev.plist" and "GoogleService-Info-Prod.plist"
        let filename = "GoogleService-Info-\(env)"
        guard let url = Bundle.main.url(forResource: filename, withExtension: "plist"),
                  let optionsDict = NSDictionary(contentsOf: url) else {
            Log.error("Can't find firebase file: \(filename)")
            return nil
        }

        return FIROptions(googleAppID: optionsDict["GOOGLE_APP_ID"] as? String ?? "",
                          bundleID: optionsDict["BUNDLE_ID"] as? String ?? "",
                          gcmSenderID: optionsDict["GCM_SENDER_ID"] as? String ?? "",
                          apiKey: optionsDict["API_KEY"] as? String ?? "",
                          clientID: optionsDict["CLIENT_ID"] as? String ?? "",
                          trackingID: optionsDict["TRACKING_ID"] as? String ?? "NA",
                          androidClientID: optionsDict["ANDROID_CLIENT_ID"] as? String ?? "",
                          databaseURL: optionsDict["DATABASE_URL"] as? String ?? "",
                          storageBucket: optionsDict["STORAGE_BUCKET"] as? String ?? "",
                          deepLinkURLScheme: optionsDict["DEEP_LINK_URL_SCHEME"] as? String ?? "")
    }

    func registerForAuthNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(FirebaseService.handleSignIn(_:)), name: Notification.Name(Auth.Notification.Name.userSignedIn), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FirebaseService.handleSignOut(_:)), name: Notification.Name(Auth.Notification.Name.userSignedOut), object: nil)
    }

    @objc func handleSignIn(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let userID = userInfo[Auth.Notification.Key.userID] as? String else {
                Log.error("Sign out notification missing userID, not subscribing")
                return
        }

        let topic = String(format: Constants.topicFormat, userID)
        Log.info("Subscribing to topic: \(topic)")

        FIRMessaging.messaging().subscribe(toTopic: topic)
    }

    @objc func handleSignOut(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let userID = userInfo[Auth.Notification.Key.userID] as? String else {
                Log.error("Sign out notification missing userID, not unsubscribing")
                return
        }

        FIRMessaging.messaging().unsubscribe(fromTopic: String(format: Constants.topicFormat, userID))
    }

}

extension FirebaseService: AppLifecycleConfigurable {

    var enabledBuildTypes: [BuildType] {
        return [.debug, .internal, .release]
    }

    func onDidLaunch(_ application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        configure()
    }

}
