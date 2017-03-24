//
//  MainViewModel.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/21/16.
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

class MainViewModel {

    let client: APIClient
    let listViewModels: [StopsListViewModel]

    init(client: APIClient, listViewModels: [StopsListViewModel]) {
        self.client = client
        self.listViewModels = listViewModels
    }

    // MARK: Properties

    var shouldShowAgencies: Bool {
        return Agency.selectedAgency == nil || client.configuration.agencyID == nil
    }

    // MARK: View Models

    var routeSearchViewModel: RouteSearchViewModel {
        return RouteSearchViewModel(client: listViewModels[0].client)
    }

    var agenciesListViewModel: AgenciesListViewModel {
        return AgenciesListViewModel(client: client)
    }

}
