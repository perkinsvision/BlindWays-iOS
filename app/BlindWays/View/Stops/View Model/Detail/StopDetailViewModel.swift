//
//  StopDetailViewModel.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 4/4/16.
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
import Swiftilities
import Alamofire
import RZVinyl

struct StopDetailArrivalViewModel: InfoItem {

    enum Style {

        case infoOnly
        case farFuture
        case nearFuture

    }

    // Public Properties

    let localizedTitle: String
    let localizedSubtitle: String?
    let localizedSupplementalText: String? = nil
    let iconImage: UIImage
    let iconLabel: String? = nil
    let hasChildren: Bool

    // should be private. Public only for unit testing purposes.
    let style: Style

    var titleColor: UIColor {
        return style == .farFuture ? Colors.Common.destructiveRed : Colors.Common.black
    }

    var accessibilityHint: String? {
        return hasChildren ? UIStrings.stopDetailAccessibilityArrivalsAction.string : nil
    }

    init(prediction: NextBusPrediction, relativeToDate now: Date = Date()) {
        hasChildren = true
        localizedTitle = prediction.minutes > 0 ? UIStrings.stopDetailArrivalsTitle(prediction.minutes).string : UIStrings.stopDetailArrivalsTitleNow.string
        localizedSubtitle = UIStrings.stopDetailArrivalsSubtitle(prediction.route, prediction.destination).string
        iconImage = Asset.icnArrival.image

        let arrival = prediction.arrivalDate
        let interval = arrival.timeIntervalSince(now)

        let hourInSeconds: TimeInterval = 60.0 * 60.0
        style = (interval < hourInSeconds ? Style.nearFuture : .farFuture)
    }

    init(localizedTitle: String, localizedSubtitle: String, iconImage: UIImage = Asset.icnArrival.image, style: Style) {
        hasChildren = false
        self.localizedTitle = localizedTitle
        self.localizedSubtitle = localizedSubtitle
        self.iconImage = iconImage
        self.style = style
    }

}

@objc
protocol StopDetailActions {
    func arrivalsTapped()
    func locationTapped()
    func enableLocationTapped()
    func goToLocationSettingsTapped()
}

class StopDetailViewModel {

    var state: ListViewModelState = .pending
    var savedStopState: ListViewModelState = .pending
    let client: APIClient
    let geo: GeoLocator
    let rangeMonitor: LocationRangeMonitor
    var lastLocation: CLLocation
    var requests = [DataRequest]()

    var stopViewModel: StopViewModel
    var arrivalsViewModel: BusArrivalsViewModel
    var arrivalViewModel: StopDetailArrivalViewModel = StopDetailArrivalViewModel(localizedTitle: UIStrings.stopDetailArrivalsLoadingTitle.string,
                                                                                  localizedSubtitle: UIStrings.stopDetailArrivalsLoadingSubtitle.string, style: .infoOnly)
    var locationViewModel: LocationViewModel = LocationViewModel(localizedTitle: UIStrings.stopDetailLocationFetchingTitle.string,
                                                                 localizedSubtitle: UIStrings.stopDetailLocationFetchingSubtitle.string,
                                                                 showDisclosureIndicator: false)
    var clueSetViewModel: ClueSetViewModel?
    var clues: [ClueViewModel] {
        if let viewModel = clueSetViewModel, viewModel.clues.flatMap({ $0.clue }).count > 0 {
            return viewModel.clues
        } else {
            return [ClueViewModel]()
        }
    }
    var hasTrackedClueUsage: Bool = false

    var userIsInVicinityOfStop: Bool {
        let vicinityMeters = CLLocationDistance(LocationConstants.metersPerMile * 0.25)
        guard lastLocation.hasValidCoordinate else {
            return false
        }

        return lastLocation.distance(from: stopViewModel.stop.location) < vicinityMeters
    }

    var mapViewModel: MapViewModel {
        return MapViewModel(stop: stopViewModel.stop, initialUserLocation: geo.location)
    }

    init(client: APIClient, geo: GeoLocator, stopViewModel: StopViewModel, arrivalsViewModel: BusArrivalsViewModel) {
        self.client = client
        self.geo = geo
        self.rangeMonitor = LocationRangeMonitor(target: stopViewModel.stop.location)
        self.lastLocation = geo.location
        self.stopViewModel = stopViewModel
        self.arrivalsViewModel = arrivalsViewModel
        if let clueSet = stopViewModel.stop.clueSet {
            self.clueSetViewModel = ClueSetViewModel(clueSet: clueSet)
        }
    }

    deinit {
        for request in requests {
            request.cancel()
        }

        if state.isRefreshing {
            state = .loaded
        }
    }

    var localizedTitle: String {
        return stopViewModel.localizedTitle
    }

    var localizedRoutesTitle: String? {
        let routeNames = stopViewModel.stop.sortedRouteNames
        guard routeNames.count > 0 else {
            return nil
        }

        // Rule of threes: also implemented in StopViewModel.
        // Refactor if you need this in a third place.
        let routeLabel = routeNames.count == 1 ? UIStrings.stopsCellRouteTitle.string : UIStrings.stopsCellRoutesTitle.string
        return "\(routeLabel) \(routeNames.joined(separator: ", "))".uppercased()
    }

    // MARK: Refresh

    func refreshStopDetail(_ completion: @escaping Block) {
        guard !state.isRefreshing else {
            Log.info("Request in progress, aborting")
            return
        }

        state = .refreshing

        let request = client.stopDetail(stopViewModel.stop.remoteID) { (result) in
            self.requests.removeAll()

            if let stop = result.value {
                self.arrivalsViewModel = BusArrivalsViewModel(client: self.client, stop: stop)
                self.stopViewModel = StopViewModel(stop: stop, showDirection: true)

                if let clueSet = self.stopViewModel.stop.clueSet {
                    self.clueSetViewModel = ClueSetViewModel(clueSet: clueSet, orientation: self.clueSetViewModel?.orientation)
                }
            }

            self.state = .loaded
            completion()
        }

        self.requests.append(request)
    }

    func refreshArrivals(_ completion: @escaping Block) {
        arrivalsViewModel.refresh { (result) in
            if let arrival = result.value?.first {
                self.arrivalViewModel = StopDetailArrivalViewModel(prediction: arrival.prediction)
            } else {
                self.arrivalViewModel = StopDetailArrivalViewModel(localizedTitle: UIStrings.stopDetailArrivalsNoResultsTitle.string,
                    localizedSubtitle: UIStrings.stopDetailArrivalsNoResultsSubtitle.string, style: .infoOnly)
            }
            completion()
        }
    }

    func startMonitoringLocationWithCallback(_ forceLocation: Bool = false, callback: @escaping Block) {
        let audioURL = Bundle.main.url(forResource: "range_warn", withExtension: "aif")
        rangeMonitor.onExitRange = {
            Accessibility.shared.alert(audio: audioURL, vibrate: true, text: UIStrings.stopDetailAccessibilityOutOfRangeWarning.string)
        }

        if GeoLocator.authorizationStatus == .yes || forceLocation {
            geo.startMonitoringLocation { [weak self] (location) in
                if let strongSelf = self {
                    strongSelf.handleGeoMonitoring(location: location, callback: callback)
                }
            }
        } else {
            self.setEnableLocationServicesPrompt()
            callback()
        }
    }

    fileprivate func handleGeoMonitoring(location: CLLocation, callback: Block) {
        if GeoLocator.authorizationStatus == .no {
            self.setEnableLocationServicesPrompt()
            callback()
        } else if location.hasValidCoordinate {
            self.locationViewModel = LocationViewModel(userLocation: location, stopLocation: self.stopViewModel.stop.location)
            if self.lastLocation.distance(from: location) > 1.0 || !self.lastLocation.hasValidCoordinate {
                callback()
                self.rangeMonitor.process(location)
                self.lastLocation = location
            }
        }
    }

    func setEnableLocationServicesPrompt() {
        let subtitle = GeoLocator.authorizationStatus == .unknown ? UIStrings.stopDetailLocationDisabledEnableSubtitle.string : UIStrings.stopDetailLocationDisabledSubtitle.string
        let dummyAccuracy = LocationViewModel.Accuracy.unknown
        let showDisclosureIndicator = (GeoLocator.authorizationStatus == .no)
        self.locationViewModel = LocationViewModel(localizedTitle: UIStrings.stopDetailLocationDisabledTitle.string,
                                                   localizedSubtitle: subtitle,
                                                   showDisclosureIndicator: showDisclosureIndicator,
                                                   titleColor: dummyAccuracy.titleColor,
                                                   iconColor: dummyAccuracy.iconColor,
                                                   iconImage: dummyAccuracy.iconImage)
    }

    func stopMonitoringLocation() {
        geo.stopMonitoringLocation()
    }

    // MARK: Saved Stop

    var isSaved: Bool {
        return stopViewModel.stop.isSaved
    }

    func setSavedStop(_ saved: Bool, completion: @escaping Block) {
        guard !savedStopState.isRefreshing else {
            Log.info("Request in progress, aborting")
            return
        }

        savedStopState = .refreshing

        client.saveStop(stopViewModel.stop.remoteID, saved: saved) { (result) in
            self.savedStopState = .pending
            if result.isSuccess {
                do {
                    self.stopViewModel.stop.isSaved = saved
                    try self.stopViewModel.stop.managedObjectContext?.rzv_saveToStoreAndWait()
                } catch {
                    Log.error("Error saving stop: \(error)")
                }

                completion()
            }
        }
    }

    // MARK: Tracking

    func trackClueUsage() {
        guard !hasTrackedClueUsage else {
            return
        }

        hasTrackedClueUsage = true

        client.trackStop(stopViewModel.stop.remoteID) { (result) in
            Log.debug("Track stop result: \(result.value) err: \(result.error)")
        }
    }

    // MARK: Data

    enum Section {
        case info(rows: [InfoItemRow])
        case clues(clues: [ClueViewModel])

        var numberOfRows: Int {
            switch self {
            case .info(let rows):
                return rows.count
            case .clues(let clues):
                return clues.count
            }
        }
    }

    struct InfoItemRow {
        let infoItem: InfoItem
        let action: Selector?
    }

    var sections: [Section] {
        return [
            .info(rows: infoItemRows),
            .clues(clues: clues),
        ]
    }

    var infoItemRows: [InfoItemRow] {
        var rows = [
            InfoItemRow(infoItem: arrivalViewModel, action: #selector(StopDetailActions.arrivalsTapped)),
        ]

        if GeoLocator.authorizationStatus == .no {
            rows.append(InfoItemRow(infoItem: locationViewModel, action: #selector(CommonActions.launchAppSettings)))
        } else if GeoLocator.authorizationStatus == .unknown {
            rows.append(InfoItemRow(infoItem: locationViewModel, action: #selector(StopDetailActions.enableLocationTapped)))
        } else {
            rows.append(InfoItemRow(infoItem: locationViewModel, action: #selector(StopDetailActions.locationTapped)))
        }

        return rows
    }

    var locationItemIndexPath: IndexPath? {
        for (sectionIndex, section) in sections.enumerated() {
            switch section {
            case .info(let rows):
                for (rowIndex, row) in rows.enumerated() {
                    if row.infoItem is LocationViewModel {
                        return IndexPath(row: rowIndex, section: sectionIndex)
                    }
                }
            default: break
            }
        }

        return nil
    }

    var editClueSetViewModel: EditClueSetViewModel? {
        let geo = GeoLocator(locationMode: .oneShot)
        geo.manager.desiredAccuracy = kCLLocationAccuracyBest
        return EditClueSetViewModel(client: client, geo: geo, stop: self.stopViewModel.stop)
    }

    // MARK: Clue Actions

    func confirmClue(_ clueViewModel: ClueViewModel, completion: @escaping Block) {
        if let clue = clueViewModel.clue as? Clue {
            client.confirmClueForStop(stopViewModel.stop.remoteID, clueID: clue.remoteID, completion: { _ in
                completion()
            })
        }
    }

    func rateClue(_ clueViewModel: ClueViewModel, completion: @escaping Block) {
        if let clue = clueViewModel.clue as? Clue {
            client.rateHelpfulClueForStop(stopViewModel.stop.remoteID, clueID: clue.remoteID, completion: { _ in
                completion()
            })
        }
    }

    // MARK: Empty State

    var noCluesEmptyState: EmptyState? {
        if self.clues.count == 0 {
            var style = Appearance.defaultEmptyStateStyle
            style.layout = .imageBottom
            return ListEmptyState(style: style,
                                  message: UIStrings.stopDetailCluesetEmptyStateNoCluesMessage.string,
                                  image: UIScreen.main.rz_isIPhone4ScreenSize() ? nil : Asset.imgEmptyNoclues.image,
                                  actionTitle: UIStrings.stopDetailCluesetEmptyStateNoCluesActionTitle.string,
                                  action: #selector(StopDetailViewController.addClue))

        } else {
            return nil
        }
    }

}
