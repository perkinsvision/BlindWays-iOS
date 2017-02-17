//
//  ListViewModel.swift
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
import Alamofire

enum ViewModelResult<Value, AFError> {

    case success(Value)
    case failure(Error)

    /// Returns `true` if the result is a success, `false` otherwise.
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    /// Returns `true` if the result is a failure, `false` otherwise.
    var isFailure: Bool {
        return !isSuccess
    }

    /// Returns the associated value if the result is a success, `nil` otherwise.
    var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }

}

enum ListViewModelState {

    case pending
    case refreshing
    case loaded
    case error(error: Error?)

    var isRefreshing: Bool {
        switch self {
        case .refreshing: return true
        default: return false
        }
    }

    var isLoaded: Bool {
        switch self {
        case .loaded: return true
        default: return false
        }
    }

    var isPending: Bool {
        switch self {
        case .pending: return true
        default: return false
        }
    }

}

protocol ListViewModel {

    // General

    var state: ListViewModelState { get }
    var localizedTitle: String { get }
    var analyticsPageName: String { get }

    // Empty State

    var activeEmptyState: EmptyState? { get }
    var noDataEmptyState: EmptyState { get }
    var errorEmptyState: EmptyState { get }

}

struct ListEmptyState: EmptyState {

    var style: EmptyStateStyle?
    var message: String
    var image: UIImage?
    var actionTitle: String?
    var action: Selector?

}

@objc protocol ListViewModelActions {

    func refresh()
    func refreshWithForceLocation()

}

class BaseListViewModel<T>: ListViewModel {

    typealias BaseFetchedListViewModelCompletion = (ViewModelResult<[T], NSError>) -> Void

    let client: APIClient
    var state: ListViewModelState = .pending {
        didSet {
            stateDidChangeHandler?(state)
        }
    }
    var listObjects: [T] = [T]()
    var requests: [DataRequest] = [DataRequest]()
    var stateDidChangeHandler: ((ListViewModelState) -> Void)?

    init(client: APIClient) {
        self.client = client
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
        fatalError("Subclasses must implement")
    }

    var analyticsPageName: String {
        fatalError("Subclasses must implement")
    }

    var allowsManualRefresh: Bool {
        return false
    }

    func refresh(_ completion: @escaping BaseFetchedListViewModelCompletion) {
        fatalError("Subclasses must implement refresh()")
    }

    // MARK: Empty State

    var activeEmptyState: EmptyState? {
        switch state {
        case .error(let error):
            if let error = error as? NSError, error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                return noInternetEmptyState
            } else {
                return errorEmptyState
            }
        case .loaded where listObjects.count == 0:
            return noDataEmptyState
        default:
            return nil
        }
    }

    var noDataEmptyState: EmptyState {
        return ListEmptyState(style: Appearance.defaultEmptyStateStyle,
            message: UIStrings.emptyStateGenericNoData.string,
            image: nil,
            actionTitle: nil,
            action: nil)
    }

    var errorEmptyState: EmptyState {
        return ListEmptyState(style: Appearance.defaultEmptyStateStyle,
            message: UIStrings.emptyStateGenericNoData.string,
            image: Asset.imgEmptyGeneric.image,
            actionTitle: UIStrings.commonTryAgain.string,
            action: #selector(ListViewModelActions.refresh))
    }

    var noInternetEmptyState: EmptyState {
        return ListEmptyState(style: Appearance.defaultEmptyStateStyle,
            message: UIStrings.emptyStateGenericNoInternet.string,
            image: Asset.imgEmptyConnection.image,
            actionTitle: UIStrings.commonTryAgain.string,
            action: #selector(ListViewModelActions.refresh))
    }

}
