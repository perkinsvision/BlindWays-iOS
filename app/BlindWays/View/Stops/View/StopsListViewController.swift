//
//  StopsListViewController.swift
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

import UIKit
import Anchorage
import MapKit

class StopsListViewController: UIViewController, ListViewController {

    let viewModel: StopsListViewModel

    var tableView: UITableView!

    // MARK: Init

    init(viewModel: StopsListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        self.viewModel.stopsListViewModelDelegate = self

        navigationItem.title = viewModel.localizedTitle
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    override func loadView() {
        view = UIView()
        tableView = ControlContainableTableView()
        view.addSubview(tableView)
    }

    func configureLayout() {
        tableView.edgeAnchors == view.edgeAnchors
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureStyle()
        configureTableView()
        updateRefreshState()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
        NotificationCenter.default.addObserver(self, selector: #selector(StopsListViewController.handleAppForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func configureStyle() {
        view.backgroundColor = Colors.Common.marineBlue
        tableView.backgroundColor = .clear
    }

    func refresh() {
        per_hideEmptyState()

        viewModel.refresh { _ in
            self.updateRefreshState()
            self.per_updateEmptyState(self.viewModel)
            self.tableView.reloadData()
        }
        updateRefreshState()
    }

    func refreshWithForceLocation() {
        if let nearbyViewModel = viewModel as? NearbyStopsViewModel {
            // ??? Status is unknown so set this flag to trigger the location prompt
            // on next refresh.
            nearbyViewModel.forceLocationPrompt = true
            refresh()
        }
    }

    // MARK: Refresh

    func updateRefreshState() {
        if viewModel.state.isRefreshing {
            tableView.tableFooterView = refreshIndicatorFooterView
            Accessibility.shared.announce(UIStrings.stopsAccessibilityRefreshingTitle(viewModel.localizedTitle).string)
        } else {
            if viewModel.allowsManualRefresh {
                tableView.tableFooterView = refreshButtonFooterView
            } else {
                tableView.tableFooterView = UIView()
            }
            Accessibility.shared.announce(UIStrings.stopsAccessibilityDidRefreshTitle(viewModel.listObjects.count).string) { (_, success) in
                if success {
                    self.tableView.rz_accessibilityFocusOnFirstCell()
                }
            }

        }
    }

    var refreshButtonFooterView: UIView {
        let view = footerView

        let button = UIButton(type: .system)
        button.frame = view.bounds
        button.tintColor = .white
        button.backgroundColor = .clear
        button.setTitle(UIStrings.stopsRefreshButtonTitle.string, for: .normal)
        button.setImage(Asset.icnRefresh.image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)

        button.addTarget(self, action: #selector(StopsListViewController.refresh), for: .touchUpInside)
        view.addSubview(button)

        return view
    }

    var refreshIndicatorFooterView: UIView {
        let view = footerView

        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.startAnimating()
        activity.frame = view.bounds
        view.addSubview(activity)

        return view
    }

    var footerView: UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 64))
        view.backgroundColor = .clear
        return view
    }

    func emptyStateContentOffset() -> CGPoint {
        return CGPoint(x: 0, y: -MainViewController.segmentedControlPadding)
    }

    func per_showEmptyState(_ emptyState: EmptyState) {
        self.rzv_showEmptyState(emptyState, centerOffset: emptyStateContentOffset()) {
            self.tableView.alpha = 0.0
            self.tableView.accessibilityElementsHidden = true
            if let emptyView = self.activeEmptyState?.view {
                emptyView.topAnchor >= self.tableView.topAnchor
            }
        }
    }

    // MARK: App Lifecycle

    func handleAppForeground() {
        refresh()
    }
}

extension StopsListViewController: StopsListViewModelDelegate {

    func requestAgencyChange() {
        let agenciesListViewController = AgenciesListViewController(viewModel: viewModel.agenciesListViewModel,
                                                                    mode: .cityChanged)
        present(UINavigationController(rootViewController: agenciesListViewController), animated: true, completion: nil)
    }

}

extension StopsListViewController: UITableViewDataSource, UITableViewDelegate {

    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 84
        tableView.register(InfoItemCell.self, forCellReuseIdentifier: InfoItemCell.rz_reuseID)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoItemCell.rz_reuseID, for: indexPath)

        if let cell = cell as? InfoItemCell {
            cell.viewModel = viewModel.listObjects[indexPath.row]
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stopDetailViewModel = viewModel.detailViewModelForStop(at: indexPath)
        let detailVC = StopDetailViewController(viewModel: stopDetailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
