//
//  DispatchTimer.swift
//  BlindWays
//
//  Created by Zev Eisenberg on 6/28/16.
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

// Timer code inspired by https://gist.github.com/maicki/7622108

private extension DispatchTimeInterval {

    init(timeInterval: TimeInterval) {
        self = DispatchTimeInterval.nanoseconds(Int(timeInterval * TimeInterval(NSEC_PER_SEC)))
    }

}

class DispatchTimer {

    fileprivate var timer: DispatchSourceTimer?
    fileprivate let interval: DispatchTimeInterval
    fileprivate let queue: DispatchQueue
    fileprivate let leeway: TimeInterval
    fileprivate let block: Block

    init(interval: TimeInterval, queue: DispatchQueue = DispatchQueue.main, leeway: TimeInterval? = nil, block: @escaping Block) {

        self.interval = DispatchTimeInterval(timeInterval: interval)
        self.queue = queue
        self.leeway = leeway ?? (interval / 10) // default value: 10% of the interval
        self.block = block
    }

    func resume() {
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0), queue: queue)
            guard let timer = timer else { return }
            timer.scheduleRepeating(
                deadline: DispatchTime.now() + interval,
                interval: interval,
                leeway: DispatchTimeInterval(timeInterval: leeway))
            timer.setEventHandler(handler: block)
            timer.resume()
        }
    }

    func pause() {
        timer?.cancel()
        timer = nil
    }

    deinit {
        pause()
    }

}
