//
//  AgenciesListViewModel.swift
//  BlindWays
//
//  Created by Fabien Legoupillot on 1/24/17.
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

class AgenciesListViewModel: BaseListViewModel<AgencyViewModel> {

    let geo: GeoLocator = {
        let geo = GeoLocator(locationMode: .oneShot)
        geo.manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        return geo
    }()

    override init(client: APIClient) {
        super.init(client: client)
    }

    var isFiltered: Bool = false

    // MARK: Empty State

    override var noDataEmptyState: EmptyState {
        return ListEmptyState(style: Appearance.defaultEmptyStateStyle,
                              message: UIStrings.agenciesEmptyStateNoResults.string,
                              image: Asset.imgEmptyNostops.image,
                              actionTitle: UIStrings.commonTryAgain.string,
                              action: #selector(ListViewModelActions.refresh))
    }

    // MARK: BaseListViewModel

    override var localizedTitle: String {
        return UIStrings.agenciesTitle.string
    }

    override var analyticsPageName: String {
        return "Agencies"
    }

    // MARK: Actions

    func selectCell(at index: Int) {
        do {
            let agency = listObjects[index].agency
            agency.isSelected = true
            if let context = agency.managedObjectContext,
                let agencies = Agency.rzv_all(in: context) as? [Agency] {
                for otherAgency in agencies {
                    otherAgency.isSelected = agency.remoteID == otherAgency.remoteID
                }
            }
            try agency.managedObjectContext?.rzv_saveToStoreAndWait()

            client.configuration.agencyID = String(agency.remoteID)
        } catch {
            Log.error("Error when selecting agency: \(error)")
        }
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

        state = .refreshing

        if GeoLocator.authorizationStatus == .yes {
            geo.requestLocationUpdate { currentLocation in
                self.fetchAgencies(currentLocation: currentLocation, completion: completion)
            }
        } else {
            fetchAgencies(currentLocation: nil, completion: completion)
        }
    }

    private func fetchAgencies(currentLocation: CLLocation?, completion: @escaping BaseFetchedListViewModelCompletion) {
        let request = self.client.allAgencies { result in
            self.requests.removeAll()

            if let agencies = result.value, result.isSuccess {
                self.state = .loaded
                let viewModels = self.agencyViewModels(agencies: agencies, currentLocation: currentLocation)
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
        }

        self.requests.append(request)
    }

    private func agencyViewModels(agencies: [Agency], currentLocation: CLLocation?) -> [AgencyViewModel] {
        var agencyModels: [AgencyViewModel] = agencies.map { agency in
            var distance: CLLocationDistance = 0

            if let currentLocation = currentLocation, let agencyLocation = agency.location,
                CLLocationCoordinate2DIsValid(currentLocation.coordinate) &&
                    CLLocationCoordinate2DIsValid(agencyLocation.coordinate) {
                distance = currentLocation.distance(from: agencyLocation)
            }

            return AgencyViewModel(agency: agency, distance: distance)
        }
        if isFiltered {
            let fiftyMiles: CLLocationDistance = 80467.2
            agencyModels = agencyModels.filter { model in
                return model.distance < fiftyMiles
            }
        }
        return agencyModels.sorted { viewModel1, viewModel2 in
            viewModel1.distance > viewModel2.distance
        }
    }

}
