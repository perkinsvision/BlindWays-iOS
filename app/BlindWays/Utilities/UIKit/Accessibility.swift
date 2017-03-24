//
//  Accessibility.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/21/16.
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
import AVFoundation
import AudioToolbox
import Swiftilities

/// A set of handy UIAccessibility helpers
class Accessibility: NSObject {

    typealias AccessibilityAnnounceCompletion = (_ announcedString: String?, _ success: Bool) -> Void
    typealias AudioPlayedCompletion = (_ success: Bool) -> Void

    static let shared = Accessibility()

    fileprivate var announceCompletion: AccessibilityAnnounceCompletion?

    fileprivate var audioPlayer: AVAudioPlayer?
    fileprivate var audioCompletion: AudioPlayedCompletion?
    fileprivate let speechSynth: AVSpeechSynthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(Accessibility.handleAnnounceDidFinish(notification:)), name: Notification.Name.UIAccessibilityAnnouncementDidFinish, object: nil)
    }

    /**
     Check if VoiceOver is currently running (UIAccessibilityIsVoiceOverRunning()).

     - returns: true if running, else false.
     */
    static func isVoiceOverRunning() -> Bool {
        return UIAccessibilityIsVoiceOverRunning()
    }

    /**
     Announce a message via VoiceOver with optional completion callback (UIAccessibilityAnnouncementNotification).

     - parameter text:       The text to be spoken.
     - parameter completion: A block to be invoked when the announcement has completed.
     */
    func announce(_ text: String, completion: AccessibilityAnnounceCompletion? = nil) {
        announceCompletion = completion
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text)
    }

    func handleAnnounceDidFinish(notification: Notification) {
        if let completion = announceCompletion, let userInfo = notification.userInfo {
            completion(userInfo[UIAccessibilityAnnouncementKeyStringValue] as? String, userInfo[UIAccessibilityAnnouncementKeyWasSuccessful] as? Bool ?? false)
            announceCompletion = nil
        }
    }

    func alert(audio: URL?, vibrate: Bool, text: String) {
        guard Accessibility.isVoiceOverRunning() else {
            return
        }

        if vibrate {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }

        playAudio(url: audio) { [weak self] _ in
            let utterance = AVSpeechUtterance(string: text)
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 1.25
            self?.speechSynth.speak(utterance)
        }
    }

    fileprivate func playAudio(url: URL?, completion: @escaping AudioPlayedCompletion) {
        guard let url = url else {
            Log.error("Could not find audio.")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            audioCompletion = completion
            self.audioPlayer = player
            player.play()
        } catch {
            Log.error("Error attempting to play audio \(error)")
            completion(false)
        }
    }

    /**
     Notify VoiceOver that layout has changed and focus on an optionally provided view (UIAccessibilityLayoutChangedNotification).

     - parameter focusView: A view to be focussed on as part of the layout change.
     */
    func layoutChanged(focusView: UIView? = nil) {
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, focusView)
    }

    /**
     Notify VoiceOver that screen has changed and focus on an optionally provided view (UIAccessibilityScreenChangedNotification).

     - parameter focusView: A view to be focussed on as part of the layout change.
     */
    func screenChanged(focusView: UIView? = nil) {
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, focusView)
    }

}

extension Accessibility: AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully success: Bool) {
        audioCompletion?(success)
        audioCompletion = nil
        audioPlayer = nil
    }

}

// MARK: - UIAccessibility helpers for UITableView
extension UITableView {

    /**
     Focus the VoiceOver layout on the first cell of this UITableView instance.
     If the table view has no rows, this is a no-op.
     */
    func rz_accessibilityFocusOnFirstCell() {
        if let numberOfSections = dataSource?.numberOfSections?(in: self), numberOfSections > 0,
            let numberOfRows = dataSource?.tableView(self, numberOfRowsInSection: 0), numberOfRows > 0 {
            let cell = cellForRow(at: IndexPath(row: 0, section: 0))
            Accessibility.shared.layoutChanged(focusView: cell)
        }
    }

}
