//
//  BusArrivalsViewModel.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/30/16.
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
import Swiftilities

class BusArrivalsViewModel: BaseListViewModel<BusArrivalViewModel> {

    let stop: Stop
    var lastRefreshDate: Date?

    init(client: APIClient, stop: Stop) {
        self.stop = stop
        super.init(client: client)
    }

    // MARK: Properties

    override var localizedTitle: String {
        return stop.name
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

        guard let agency = Agency.selectedAgency, let agencyID = agency.nextBusAgencyID else {
            Log.error("Incorrect agency")
            completion(.failure(ViewModelError.unknown.error))
            return
        }

        guard let routes = stop.routes?.array as? [Route] else {
            completion(.failure(ViewModelError.unknown.error))
            return
        }

        guard let stopGTFS = stop.gtfsID else {
            completion(.failure(ViewModelError.unknown.error))
            return
        }

        state = .refreshing

        let routeIDs = routes.flatMap({ $0.nextBusID })

        let requests = client.predictionsForStop(stopGTFS, routeTags: routeIDs, agency: agencyID) { (result) in
            self.listObjects.removeAll()
            self.requests.removeAll()
            self.lastRefreshDate = Date()

            if let predictions = result.value, result.isSuccess {
                self.state = .loaded

                let viewModels = predictions.map(BusArrivalViewModel.init(prediction:))
                self.listObjects = viewModels
                completion(.success(viewModels))
            } else if let error = result.error {
                self.state = .error(error: error)
                completion(.failure(error))
            }
        }

        self.requests.append(contentsOf: requests)
    }

    override var noDataEmptyState: EmptyState {
        return ListEmptyState(style: Appearance.defaultEmptyStateStyle,
                              message: UIStrings.stopsArrivalsEmptyStateNoData.string,
                              image: Asset.imgEmptyNostops.image,
                              actionTitle: UIStrings.commonTryAgain.string,
                              action: #selector(ListViewModelActions.refresh))
    }

}
