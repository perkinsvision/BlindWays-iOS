//
//  BusArrivalsViewController.swift
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

import Anchorage

class BusArrivalsViewController: UIViewController, ListViewController {
    let viewModel: BusArrivalsViewModel

    var tableView: UITableView!

    fileprivate var timer: DispatchTimer?

    fileprivate static let refreshInterval = TimeInterval(60.0)

    // MARK: Init

    init(viewModel: BusArrivalsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        navigationItem.rz_setTextPronounceable(viewModel.localizedTitle)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    override func loadView() {
        view = UIView()
        tableView = ControlContainableTableView(frame: CGRect.zero, style: .grouped)
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
        configureRefreshButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableHeader()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let pollInterval = TimeInterval(1.0)
        let leeway: TimeInterval = 1.0 / 60.0 // don't be off by more than a frame
        timer = DispatchTimer(interval: pollInterval, leeway: leeway, block: { [weak self] in
            if let lastRefresh = self?.viewModel.lastRefreshDate {

                let now = Date()
                let intervalSinceLastRefresh = now.timeIntervalSince(lastRefresh)
                if let refreshing = self?.viewModel.state.isRefreshing, intervalSinceLastRefresh >= BusArrivalsViewController.refreshInterval && !refreshing {
                    self?.refresh(announceWithVoiceOver: true)
                }
            }
            self?.updateRefreshState(announceWithVoiceOver: false)
        })
        timer?.resume()

        refresh(announceWithVoiceOver: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.pause()
    }

    func configureStyle() {
        view.backgroundColor = Colors.Common.marineBlue
        tableView.backgroundColor = .clear
    }

    func refreshTapped() {
        refresh(announceWithVoiceOver: true)
    }

    func refresh(announceWithVoiceOver: Bool) {
        per_hideEmptyState()

        viewModel.refresh { _ in
            self.updateRefreshState(announceWithVoiceOver: announceWithVoiceOver)
            self.per_updateEmptyState(self.viewModel)
            self.tableView.reloadData()
        }
        updateRefreshState(announceWithVoiceOver: announceWithVoiceOver)
    }

    // MARK: Refresh

    func updateRefreshState(announceWithVoiceOver: Bool = false) {
        if viewModel.state.isRefreshing {
            // ??? - Changing the navigationItem causes VoiceOver to change focus
            // and interrupt announcements, so only show a spinner if VO is not running
            if !Accessibility.isVoiceOverRunning() {
                configureRefreshSpinner()
            }

            if announceWithVoiceOver {
                Accessibility.shared.announce(UIStrings.stopsArrivalsAccessibilityRefreshingTitle.string)
            }
        } else {
            if !Accessibility.isVoiceOverRunning() {
                configureRefreshButton()
            }

            if announceWithVoiceOver {
                Accessibility.shared.announce(UIStrings.stopsArrivalsAccessibilityDidRefreshTitle(viewModel.listObjects.count).string) { (_, success) in
                    if success {
                        self.tableView.rz_accessibilityFocusOnFirstCell()
                    }
                }
            }
        }

        updateTableHeader()
    }

    func configureRefreshButton() {
        // Jump through hoops so that this bar button item is the same width as the refresh spinner
        let refreshButton = UIButton(type: .custom)
        let refreshImage = Asset.icnRefresh.image
        refreshButton.setImage(refreshImage, for: .normal)
        refreshButton.addTarget(self, action: #selector(BusArrivalsViewController.refreshTapped), for: .touchUpInside)
        refreshButton.frame.size = refreshImage.size

        let refreshItem = UIBarButtonItem(customView: refreshButton)
        refreshItem.accessibilityLabel = UIStrings.commonRefresh.string

        self.navigationItem.rightBarButtonItem = refreshItem
    }

    func configureRefreshSpinner() {
        // Jump through hoops so that this bar button item is the same width as the refresh button
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        spinner.startAnimating()

        let spinnerContainer = UIView("spinnerContainer")
        spinnerContainer.addSubview(spinner)

        spinnerContainer.frame = CGRect(x: 0, y: 0, width: Asset.icnRefresh.image.size.width, height: spinner.frame.height)
        spinner.center = CGPoint(x: spinnerContainer.bounds.midX, y: spinnerContainer.bounds.midY)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinnerContainer)
    }

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter
    }()

    func updateTableHeader() {
        let formattedString: UIStrings? = {
            if viewModel.state.isRefreshing || viewModel.state.isPending {
                return UIStrings.stopsArrivalsAccessibilityRefreshingTitle
            } else if let lastRefreshDate = viewModel.lastRefreshDate, viewModel.listObjects.count > 0 {
                let now = Date()
                let timeSinceLastUpdate = now.timeIntervalSince(lastRefreshDate)
                let timeUntilNextUpdate = BusArrivalsViewController.refreshInterval - timeSinceLastUpdate
                let secondsUntilNextUpdate = Int(timeUntilNextUpdate)
                let userFacingSecondsUntilNextUpdate = max(1, secondsUntilNextUpdate + 1) // never show 0 or below
                let userFacingSecondsString = String(userFacingSecondsUntilNextUpdate)

                switch userFacingSecondsUntilNextUpdate {
                case 1: return UIStrings.stopsArrivalsNextRefreshingSingularSecondsFormat(userFacingSecondsString)
                default: return UIStrings.stopsArrivalsNextRefreshingPluralSecondsFormat(userFacingSecondsString)
                }
            } else {
                return nil
            }
        }()

        if let formattedString = formattedString {
            tableView.rz_setHeaderText(formattedString.string, labelAccessibilityTraits: UIAccessibilityTraitUpdatesFrequently)
        }
    }

    func emptyStateContentOffset() -> CGPoint {
        return CGPoint.zero
    }
}

extension BusArrivalsViewController: UITableViewDataSource, UITableViewDelegate {

    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 84
        tableView.tableFooterView = UIView()
        tableView.register(BusArrivalCell.self, forCellReuseIdentifier: BusArrivalCell.rz_reuseID)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusArrivalCell.rz_reuseID, for: indexPath)

        if let cell = cell as? BusArrivalCell {
            cell.viewModel = viewModel.listObjects[indexPath.row]
        }

        return cell
    }

}
