//
//  SavedStopsViewModel.swift
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

class SavedStopsViewModel: StopsListViewModel {

    // MARK: Properties

    override var backButtonTitle: String {
        return UIStrings.stopsBackButtonTitleSaved.string
    }

    override var localizedTitle: String {
        return UIStrings.stopsSavedTitle.string
    }

    override var analyticsPageName: String {
        return "Saved"
    }

    // MARK: Refresh

    override func refresh(_ completion: @escaping BaseFetchedListViewModelCompletion) {
        state = .refreshing

        client.savedStops { result in
            if let stops = result.value, result.isSuccess {
                self.state = .loaded
                let viewModels = stops.map({ StopViewModel(stop: $0, showDirection: true) })
                self.listObjects = viewModels
                completion(.success(viewModels))
            } else if let error = result.error {
                self.state = .error(error: error)
                completion(.failure(error))
            }
        }
    }

    // MARK: Empty State

    override var noDataEmptyState: EmptyState {
        return ListEmptyState(style: Appearance.defaultEmptyStateStyle,
                              message: UIStrings.stopsEmptyStateNoSaved.string,
                              image: Asset.imgEmptyNostops.image,
                              actionTitle: nil,
                              action: nil)
    }

}
