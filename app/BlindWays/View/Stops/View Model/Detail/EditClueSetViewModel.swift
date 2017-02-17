//
//  EditClueSetViewModel.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 4/26/16.
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

import Swiftilities
import Alamofire
import CoreLocation
import BonMot

enum ClueSlot: Int {

    case farLeft
    case nearLeft
    case busStopSign
    case nearRight
    case farRight

    func localizedSectionTitleForStopName(_ stopName: String) -> String {
        switch self {
        case .busStopSign: return UIStrings.stopDetailEditCluesetSectionHeaderClueSignTitle.string
        default: return UIStrings.stopDetailEditCluesetSectionHeaderClueTitle.string
        }
    }

    var localizedSectionDetail: String {
        switch self {
        case .farLeft: return  UIStrings.stopDetailEditCluesetSectionHeaderDetailLeftFar.string
        case .nearLeft: return  UIStrings.stopDetailEditCluesetSectionHeaderDetailLeftNear.string
        case .busStopSign: return  UIStrings.stopDetailEditCluesetSectionHeaderDetailBusStopSign.string
        case .nearRight: return  UIStrings.stopDetailEditCluesetSectionHeaderDetailRightNear.string
        case .farRight: return  UIStrings.stopDetailEditCluesetSectionHeaderDetailRightFar.string
        }
    }

    var localizedAccessibilityTitle: String {
        switch self {
        case .farLeft: return  UIStrings.stopDetailEditCluesetAccessibilityLeftFarTitle.string
        case .nearLeft: return  UIStrings.stopDetailEditCluesetAccessibilityLeftNearTitle.string
        case .busStopSign: return  UIStrings.stopDetailEditCluesetAccessibilityBusStopSignTitle.string
        case .nearRight: return  UIStrings.stopDetailEditCluesetAccessibilityRightNearTitle.string
        case .farRight: return  UIStrings.stopDetailEditCluesetAccessibilityRightFarTitle.string
        }
    }

}

class EditClueField<T> {

    let title: String
    var value: T?

    init(title: String, value: T?) {
        self.title = title
        self.value = value
    }

}

class EditClueViewModel {
    let clueSlot: ClueSlot
    let sectionTitle: String
    let sectionDetail: String
    var type: String? {
        didSet {
            if let type = type, type != ClueType.otherType {
                hint = nil
            }
        }
    }
    var hint: String?
    var onGrassOrDirtField: EditClueField<Bool>
    var awayFromCurbField: EditClueField<Bool>

    init(clueSlot: ClueSlot, stopName: String, clue: Clue?) {
        self.clueSlot = clueSlot
        self.sectionTitle = clueSlot.localizedSectionTitleForStopName(stopName)
        self.sectionDetail = clueSlot.localizedSectionDetail
        self.type = clue?.type
        self.hint = clue?.hint

        self.onGrassOrDirtField = EditClueField(title: UIStrings.stopDetailEditCluesetFieldOnGrassTitle.string, value: clue?.onGrassOrDirt)

        let awayFromCurbString: String
        if Locale.current.isMetric {
            awayFromCurbString = UIStrings.stopDetailEditCluesetFieldAwayFromCurbMetricTitle.string
        } else {
            awayFromCurbString = UIStrings.stopDetailEditCluesetFieldAwayFromCurbImperialTitle.string
        }

        self.awayFromCurbField = EditClueField(title: awayFromCurbString, value: clue?.awayFromCurb)
    }

    var isBusStopSign: Bool {
        return clueSlot == .busStopSign
    }

    var landmarkClueTypes: [ClueType] {
        return RemoteConfig.defaultConfig()?.landmarkClueTypes ?? [ClueType]()
    }

    var busStopClueTypes: [ClueType] {
        return RemoteConfig.defaultConfig()?.busStopClueTypes ?? [ClueType]()
    }

    var otherType: ClueType? {
        if let types = RemoteConfig.defaultConfig()?.landmarkClueTypes {
            let results = types.filter({ $0.type == ClueType.otherType })
            return results.count == 1 ? results[0] : nil
        }

        return nil
    }

    // MARK: Table

    enum Section {
        case clueTypes(clueTypes: [ClueType])
        case placement(fields: [EditClueField<Bool>])

        var sectionTitle: String {
            switch self {
            case .clueTypes(_): return ""
            case .placement(_): return UIStrings.stopDetailEditCluesetSectionHeaderPlacementTitle.string
            }
        }
    }

    var sections: [Section] {
        return [
            Section.clueTypes(clueTypes: clueTypes),
            Section.placement(fields: [
                onGrassOrDirtField,
                awayFromCurbField,
                ]
            ),
        ]
    }

    var clueTypes: [ClueType] {
        return isBusStopSign ? busStopClueTypes : landmarkClueTypes
    }

}

class EditClueSetViewModel {

    let client: APIClient
    let geo: GeoLocator
    let stop: Stop
    var preselectedSlotIndex: Int?
    let clueSet: ClueSet
    let localizedTitle: String
    let leftOfSignFar: EditClueViewModel
    let leftOfSignNear: EditClueViewModel
    let busStopSign: EditClueViewModel
    let rightOfSignNear: EditClueViewModel
    let rightOfSignFar: EditClueViewModel
    var note: EditClueField<String>
    var request: DataRequest?

    init?(client: APIClient, geo: GeoLocator, stop: Stop) {
        guard let  clueSet = stop.clueSet else {
            return nil
        }

        self.client = client
        self.geo = geo
        self.stop = stop
        self.localizedTitle = stop.name
        self.clueSet = clueSet

        self.leftOfSignFar = EditClueViewModel(clueSlot: .farLeft, stopName: stop.name, clue: clueSet.leftOfSignFar)
        self.leftOfSignNear = EditClueViewModel(clueSlot: .nearLeft, stopName: stop.name, clue: clueSet.leftOfSignNear)
        self.busStopSign = EditClueViewModel(clueSlot: .busStopSign, stopName: stop.name, clue: clueSet.busStopSign)
        self.rightOfSignNear = EditClueViewModel(clueSlot: .nearRight, stopName: stop.name, clue: clueSet.rightOfSignNear)
        self.rightOfSignFar = EditClueViewModel(clueSlot: .farRight, stopName: stop.name, clue: clueSet.rightOfSignFar)
        self.note = EditClueField(title: "", value: clueSet.note)
    }

    deinit {
        if let request = request {
            request.cancel()
        }
    }

    var stopName: String {
        return stop.name
    }

    lazy var clueViewModels: [EditClueViewModel] = self.cluesAsList()

    func cluesAsList() -> [EditClueViewModel] {
        return [
            leftOfSignFar,
            leftOfSignNear,
            busStopSign,
            rightOfSignNear,
            rightOfSignFar,
            ]
    }

    typealias UpdateClueSetCompletion = (ViewModelResult<Any, AFError>) -> Void

    func updateClueSet(_ completion: @escaping UpdateClueSetCompletion) {
        guard request == nil else {
            Log.info("Request in progress, aborting")
            return
        }

        request = client.updateClueSetForStop(stop.remoteID, clueSet: self.jsonRepresentation) { (result) in
            self.request = nil

            if let value = result.value, result.isSuccess {
                completion(.success(value))
            } else {
                completion(.failure(result.error ?? ViewModelError.unknown.error))
            }
        }
    }

    typealias UpdateStopLocationCompletion = (ViewModelResult<CLLocation, NSError>) -> Void

    func updateStopLocation(_ completion: @escaping UpdateStopLocationCompletion) {
        guard !geo.isActive && request == nil else {
            Log.info("Request in progress, aborting")
            return
        }

        geo.requestLocationUpdate { (locationResult) in
            if locationResult.hasValidCoordinate {
                self.client.updateLocationForStop(self.stop.remoteID, location: locationResult, completion: { _ in
                    completion(.success(locationResult))
                })
            } else {
                completion(.success(locationResult))
            }
        }
    }

    // MARK: Navigation

    func nextUnfilledSlot(from startSlot: ClueSlot) -> ClueSlot? {
        let navigableOrderedSlots: [ClueSlot] = [.busStopSign, .nearLeft, .farLeft, .nearRight, .farRight]
        guard let startSlotIndex = navigableOrderedSlots.index(of: startSlot) else {
            return nil
        }

        for index in startSlotIndex ..< navigableOrderedSlots.count {
            let nextIndex = index + 1
            if nextIndex < navigableOrderedSlots.count {
                let nextSlot = navigableOrderedSlots[nextIndex]
                if clueViewModels[nextSlot.rawValue].type == nil {
                    return nextSlot
                }
            }
        }

        return nil
    }

    // MARK: Thank You

    var thanksModalViewModel: InfoCardViewModel {

        let baseStyle = StringStyle(.alignment(.center),
            .color(Colors.Common.white)
        )

        let thanksImages = [
            Asset.photoThanksJeff,
            Asset.photoThanksJerry,
            Asset.photoThanksJoann,
            Asset.photoThanksWen,
        ]

        let randomThanksIndex = Int(arc4random_uniform(UInt32(thanksImages.count)))

        let randomThanksImage = thanksImages[randomThanksIndex].image

        return InfoCardViewModel(
            tintColor: Colors.Common.darkGrassGreen,
            messages: [
                UIStrings.stopDetailEditCluesetThanksTitle.string.styled(with: baseStyle.byAdding(.font(.systemFont(ofSize: 44.0, weight: UIFontWeightBold)))),
                UIStrings.stopDetailEditCluesetThanksMessage.string.styled(with: baseStyle.byAdding(.font(.preferredFont(forTextStyle: .headline)))),
            ],
            image: randomThanksImage,
            backgroundColor: Colors.Common.black,
            actionTitle: UIStrings.commonContinue.string,
            actionSelector: nil
        )
    }

}
