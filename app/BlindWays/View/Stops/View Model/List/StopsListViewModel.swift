//
//  StopsListViewModel.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/17/16.
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

protocol StopsListViewModelDelegate: class {

    func requestAgencyChange()

}

class StopsListViewModel: BaseListViewModel<StopViewModel> {

    weak var stopsListViewModelDelegate: StopsListViewModelDelegate?

    var backButtonTitle: String {
        fatalError("Subclasses must implement")
    }

    override init(client: APIClient) {
        super.init(client: client)
    }

    func detailViewModelForStop(at indexPath: IndexPath) -> StopDetailViewModel {
        let stopViewModel = listObjects[indexPath.row]
        let busArrivalViewModel = BusArrivalsViewModel(client: client, stop: stopViewModel.stop)
        let geo = GeoLocator(locationMode: .continuous)

        return StopDetailViewModel(client: client,
                                   geo: geo,
                                   stopViewModel: stopViewModel,
                                   arrivalsViewModel: busArrivalViewModel)
    }

    // MARK: Empty State

    override var noDataEmptyState: EmptyState {
        return ListEmptyState(style: Appearance.defaultEmptyStateStyle,
            message: UIStrings.stopsEmptyStateNoResults.string,
            image: Asset.imgEmptyNostops.image,
            actionTitle: UIStrings.commonTryAgain.string,
            action: #selector(ListViewModelActions.refresh))
    }

    var agenciesListViewModel: AgenciesListViewModel {
        return AgenciesListViewModel(client: client)
    }
}
