//
//  EditClueSetViewModel+Export.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 5/4/16.
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

private struct Constants {

    static let leftOfSignFarKey     = "left_of_sign_far"
    static let leftOfSignNearKey    = "left_of_sign_near"
    static let busStopSignKey       = "bus_stop_sign"
    static let rightOfSignNearKey   = "right_of_sign_near"
    static let rightOfSignFarKey    = "right_of_sign_far"
    static let locationKey          = "location"
    static let latKey               = "lat"
    static let lngKey               = "lng"
    static let typeKey              = "type"
    static let hintKey              = "hint"
    static let signOnGrassKey       = "on_grass_or_dirt"
    static let awayFromCurbKey      = "away_from_curb"
    static let noteKey              = "note"
}

private extension ClueSlot {

    var jsonKey: String {
        switch self {
        case .farLeft: return  Constants.leftOfSignFarKey
        case .nearLeft: return  Constants.leftOfSignNearKey
        case .busStopSign: return  Constants.busStopSignKey
        case .nearRight: return  Constants.rightOfSignNearKey
        case .farRight: return  Constants.rightOfSignFarKey
        }
    }

}

extension EditClueSetViewModel {

    var jsonRepresentation: [String: Any] {
        var json = [String: Any]()

        for viewModel in self.clueViewModels {
            json[viewModel.clueSlot.jsonKey] = NSNull()

            var dict = [String: Any]()

            if let type = viewModel.type {
                dict[Constants.typeKey] = type
                dict[Constants.signOnGrassKey] = viewModel.onGrassOrDirtField.value ?? false
                dict[Constants.awayFromCurbKey] = viewModel.awayFromCurbField.value ?? false
            }

            if let hint = viewModel.hint {
                dict[Constants.hintKey] = hint
            }

            if dict.keys.count > 0 {
                json[viewModel.clueSlot.jsonKey] = dict
            }
        }

        if let note = self.note.value {
            json[Constants.noteKey] = note
        }

        return json
    }

}
