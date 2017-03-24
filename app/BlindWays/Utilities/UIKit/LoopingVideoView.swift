//
//  LoopingVideoView.swift
//  BlindWays
//
//  Created by Zev Eisenberg on 8/5/16.
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
import AVFoundation
import Swiftilities

// Apple sample code reference for looping video player: https://developer.apple.com/library/prerelease/content/samplecode/avloopplayer/Introduction/Intro.html
// From WWDC 2016 Session 503: Advances in AVFoundation Playback https://developer.apple.com/videos/play/wwdc2016/503/
// If you change the deployment target to iOS 10+, you can dramatically simplify this code by using the new AVPlayerLooper,
// as described in the aforelinked WWDC talk.

final class LoopingVideoView: UIView {

    enum VideoGravity {

        /// Resize the video proportionally to fully fit in the view.
        case aspectFit

        /// Resize the video proportionally to fully fill the view. Video may be cropped.
        case aspectFill

        /// Stretch the video disproprotionately to fully fill the view without cropping.
        case stretch

        var rawValue: String {
            switch self {
            case .aspectFit: return AVLayerVideoGravityResizeAspect
            case .aspectFill: return AVLayerVideoGravityResizeAspectFill
            case .stretch: return AVLayerVideoGravityResize
            }
        }

        init(string: String) {
            switch string {
            case AVLayerVideoGravityResizeAspect: self = .aspectFit
            case AVLayerVideoGravityResizeAspectFill: self = .aspectFill
            case AVLayerVideoGravityResize: self = .stretch
            default: fatalError("Expected valid AVLayerVideoGravity* value, but got \(string)")
            }
        }
    }

    // Public Properties

    /// One of the following values:
    /// - `AVLayerVideoGravityResizeAspect`
    /// - `AVLayerVideoGravityResizeAspectFill`
    /// - `AVLayerVideoGravityResize`
    ///
    /// Defaults to `AVLayerVideoGravityResizeAspect`
    var videoGravity: VideoGravity {
        set {
            playerLayer.videoGravity = newValue.rawValue
        }
        get {
            return VideoGravity(string: playerLayer.videoGravity)
        }
    }

    // Private Properties

    fileprivate var isObserving = false

    init(videoURL: URL?, frame: CGRect = .zero) {
        super.init(frame: frame)

        playerLayer.player = AVQueuePlayer()

        guard let url = videoURL else {
            return
        }

        let videoAsset = AVURLAsset(url: url)
        let keys = [
            ObserverContexts.urlAssetDurationKey,
            ObserverContexts.urlAssetPlayableKey,
            ]

        videoAsset.loadValuesAsynchronously(forKeys: keys) {

            // The asset invokes its completion handler on an arbitrary queue
            // when loading is complete. Because we want to access our AVQueuePlayer
            // in our ensuing set-up, we must dispatch our handler to the main
            // queue.
            Utility.performOnMainThread {
                var durationError: NSError?
                let durationStatus = videoAsset.statusOfValue(forKey: ObserverContexts.urlAssetDurationKey, error: &durationError)
                guard durationStatus == .loaded else { fatalError("Failed to load duration property with error: \(durationError)") }

                var playableError: NSError?
                let playableStatus = videoAsset.statusOfValue(forKey: ObserverContexts.urlAssetPlayableKey, error: &playableError)
                guard playableStatus == .loaded else { fatalError("Failed to read playable duration property with error: \(playableError)") }

                guard videoAsset.isPlayable else {
                    Log.error("Can't loop since asset is not playable")
                    return
                }

                guard CMTimeCompare(videoAsset.duration, CMTime(value: 1, timescale: 100)) >= 0 else {
                    Log.error("Can't loop since asset duration is too short. Duration is \(CMTimeGetSeconds(videoAsset.duration)) seconds")
                    return
                }

                // Based on the duration fo the asset, we decide the number of player
                // items to add to achieve gapless playback fo the same asset.
                let numberOfPlayerItems = Int(1.0 / CMTimeGetSeconds(videoAsset.duration)) + 2

                for _ in 1...numberOfPlayerItems {
                    let loopItem = AVPlayerItem(asset: videoAsset)
                    self.queuePlayer?.insert(loopItem, after: nil)
                }

                self.startObserving()
                self.queuePlayer?.actionAtItemEnd = .advance
                self.queuePlayer?.play()
            }
        }

        registerForAppLifecycleNotifications()
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    func stop() {
        queuePlayer?.pause()
        stopObserving()

        queuePlayer?.removeAllItems()
        playerLayer.player = nil
    }

    // MARK: KVO

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &ObserverContexts.playerStatus {
            guard let newPlayerStatus = change?[NSKeyValueChangeKey.newKey] as? AVPlayerStatus else { return }

            if newPlayerStatus == .failed {
                Log.error("End looping since player has failed with error: \(queuePlayer?.error)")
                stop()
            }
        } else if context == &ObserverContexts.currentItem {
            guard let player = queuePlayer else { return }

            if player.items().isEmpty {
                Log.error("Play queue emptied out due to bad player item. End looping.")
                stop()
            } else {
                // Append the previous current item to the player's queue. An initial
                // change from a nil currentItem yields NSNull here. Change to make
                // sure the class is AVPlayerItem before appending it to the end
                // of the queue

                if let itemRemoved = change?[NSKeyValueChangeKey.oldKey] as? AVPlayerItem {
                    itemRemoved.seek(to: kCMTimeZero)

                    stopObserving()
                    player.insert(itemRemoved, after: nil)
                    startObserving()
                }
            }
        } else if context == &ObserverContexts.currentItemStatus {
            guard let newPlayerItemStatus = change?[NSKeyValueChangeKey.newKey] as? AVPlayerItemStatus else { return }

            if newPlayerItemStatus == .failed {
                Log.error("End looping since player item has failed with error: \(queuePlayer?.currentItem?.error)")
                stop()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

}

private extension LoopingVideoView {

    struct ObserverContexts {

        fileprivate static var playerStatus = 0
        fileprivate static var playerStatusKey = "status"
        fileprivate static var currentItem = 0
        fileprivate static var currentItemKey = "currentItem"
        fileprivate static var currentItemStatus = 0
        fileprivate static var currentItemStatusKey = "currentItem.status"
        fileprivate static var urlAssetDurationKey = "duration"
        fileprivate static var urlAssetPlayableKey = "playable"

    }

    var playerLayer: AVPlayerLayer {
        return Utility.forceCast(layer, asType: AVPlayerLayer.self)
    }

    var queuePlayer: AVQueuePlayer? {
        guard let player = playerLayer.player else {
            return nil
        }
        return Utility.forceCast(player, asType: AVQueuePlayer.self)
    }

    func registerForAppLifecycleNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LoopingVideoView.applicationDidEnterBackground),
            name: Notification.Name.UIApplicationDidEnterBackground,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LoopingVideoView.applicationWillEnterForeground),
            name: Notification.Name.UIApplicationWillEnterForeground,
            object: nil
        )
    }

    func startObserving() {
        guard let player = queuePlayer, !isObserving else { return }

        player.addObserver(self, forKeyPath: ObserverContexts.playerStatusKey, options: .new, context: &ObserverContexts.playerStatus)
        player.addObserver(self, forKeyPath: ObserverContexts.currentItemKey, options: .old, context: &ObserverContexts.currentItem)
        player.addObserver(self, forKeyPath: ObserverContexts.currentItemStatusKey, options: .new, context: &ObserverContexts.currentItemStatus)

        isObserving = true
    }

    func stopObserving() {
        guard let player = queuePlayer, isObserving else { return }

        player.removeObserver(self, forKeyPath: ObserverContexts.playerStatusKey, context: &ObserverContexts.playerStatus)
        player.removeObserver(self, forKeyPath: ObserverContexts.currentItemKey, context: &ObserverContexts.currentItem)
        player.removeObserver(self, forKeyPath: ObserverContexts.currentItemStatusKey, context: &ObserverContexts.currentItemStatus)

        isObserving = false
    }

}

// MARK: - Application Lifecycle

private extension LoopingVideoView {

    @objc func applicationDidEnterBackground() {
        playerLayer.player?.pause()
    }

    @objc func applicationWillEnterForeground() {
        playerLayer.player?.play()
    }

}
