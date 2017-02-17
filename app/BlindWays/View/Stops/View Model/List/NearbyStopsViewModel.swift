//
//  NearbyStopsViewModel.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/22/16.
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

enum CityChangePromptManager {

    // Used to make sure the user is only prompted for city change once
    private static var userHasBeenPromptedForCityChange: Bool = false

    static var shouldPrompt: Bool {
        return CityChangePromptManager.userHasBeenPromptedForCityChange
    }

    static func userPrompted() {
        CityChangePromptManager.userHasBeenPromptedForCityChange = true
    }

}

class NearbyStopsViewModel: StopsListViewModel {

    fileprivate struct TestLocations {
        static let milkStreet = CLLocation(latitude: 42.357004, longitude: -71.057619)
        static let southStation = CLLocation(latitude: 42.352586, longitude: -71.0554405)
    }

    let geo: GeoLocator
    var forceLocationPrompt: Bool = false

    init(client: APIClient, geo: GeoLocator) {
        self.geo = geo
        super.init(client: client)
    }

    // MARK: Properties

    override var backButtonTitle: String {
        return UIStrings.stopsBackButtonTitleNearby.string
    }

    override var localizedTitle: String {
        return UIStrings.stopsNearbyTitle.string
    }

    override var analyticsPageName: String {
        return "Nearby"
    }

    // MARK: Refresh

    override var allowsManualRefresh: Bool {
        return true
    }

    override func refresh(_ completion: @escaping BaseFetchedListViewModelCompletion) {
        guard !state.isRefreshing else {
            Log.info("Request in progress, aborting")
            return
        }

        if !forceLocationPrompt {
            guard GeoLocator.authorizationStatus == .yes  else {
                self.handleLocationError(completion)
                return
            }
        }

        state = .refreshing
        forceLocationPrompt = false

        let start = Date().timeIntervalSince1970
        geo.requestLocationUpdate { location in
            let end = Date().timeIntervalSince1970
            Log.info("Location fetch took: \(end - start) sec, accuracy: \(location.horizontalAccuracy)")

            if CLLocationCoordinate2DIsValid(location.coordinate) {
                self.handleLocationSuccess(location, completion: completion)
            } else {
                self.handleLocationError(completion)
            }
        }
    }

    func handleLocationSuccess(_ location: CLLocation, completion: @escaping BaseFetchedListViewModelCompletion) {
        guard cityNeedsUpdated(for: location) == false else {
            CityChangePromptManager.userPrompted()
            stopsListViewModelDelegate?.requestAgencyChange()
            self.state = .pending
            completion(.success([]))
            return
        }
        let request = self.client.nearbyStops(location: location, completion: { result in
            self.requests.removeAll()

            if let stops = result.value, result.isSuccess {
                self.state = .loaded
                let viewModels = stops.map({ StopViewModel(stop: $0, showDirection: true) })
                self.listObjects = viewModels
                completion(.success(viewModels))
            } else if let error = result.error {
                self.state = .error(error: error)
                self.listObjects.removeAll()
                completion(.failure(error))
            } else {
                self.state = .error(error: ViewModelError.unknown.error)
                self.listObjects.removeAll()
                completion(.failure(ViewModelError.unknown.error))
            }
        })

        self.requests.append(request)
    }

    func cityNeedsUpdated(for newlocation: CLLocation) -> Bool {
        guard CityChangePromptManager.shouldPrompt == false,
            let currenctAgencyLocation = Agency.selectedAgency?.location else {
            return false
        }
        let fiftyMiles: CLLocationDistance = 80467.2
        return currenctAgencyLocation.distance(from: newlocation) > fiftyMiles
    }

    func handleLocationError(_ completion: BaseFetchedListViewModelCompletion) {
        state = .error(error: ViewModelError.locationUnavailable.error)
        listObjects.removeAll()
        completion(.failure(ViewModelError.locationUnavailable.error))
    }

    // MARK: Empty State

    override var activeEmptyState: EmptyState? {
        if GeoLocator.authorizationStatus == .no {
            return noLocationServicesGoToSettingsEmptyState
        } else if GeoLocator.authorizationStatus == .unknown {
            return noLocationServicesEnableEmptyState
        } else {
            return super.activeEmptyState
        }
    }

    override var noDataEmptyState: EmptyState {
        return ListEmptyState(style: Appearance.defaultEmptyStateStyle,
            message: UIStrings.stopsEmptyStateNoNearby.string,
            image: Asset.imgEmptyNostops.image,
            actionTitle: UIStrings.commonTryAgain.string,
            action: #selector(ListViewModelActions.refresh))
    }

    var noLocationServicesGoToSettingsEmptyState: EmptyState {
        return ListEmptyState(style: Appearance.defaultEmptyStateStyle,
            message: UIStrings.stopsEmptyStateLocationServicesDisabled.string,
            image: Asset.imgEmptyLocation.image,
            actionTitle: UIStrings.stopsEmptyStateLocationSettings.string,
            action: #selector(CommonActions.launchAppSettings))
    }

    var noLocationServicesEnableEmptyState: EmptyState {
        return ListEmptyState(style: Appearance.defaultEmptyStateStyle,
                              message: UIStrings.stopsEmptyStateLocationServicesDisabled.string,
                              image: Asset.imgEmptyLocation.image,
                              actionTitle: UIStrings.stopsEmptyStateEnableLocation.string,
                              action: #selector(ListViewModelActions.refreshWithForceLocation))
    }

}
