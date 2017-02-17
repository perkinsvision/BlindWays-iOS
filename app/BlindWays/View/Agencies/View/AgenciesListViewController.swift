//
//  AgenciesListViewController.swift
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

import UIKit
import Anchorage

class AgenciesListViewController: UIViewController, ListViewController {

    enum Mode {
        case noAgencySelected
        case manualUpdate
        case cityChanged

        var headerText: String {
            let headerText: String
            switch self {
            case .noAgencySelected:
                headerText = UIStrings.agenciesDescriptionNearby.string
            case .cityChanged:
                headerText = UIStrings.agenciesDescriptionChanged.string
            case .manualUpdate:
                headerText = UIStrings.agenciesDescriptionSupported.string
            }
            return headerText
        }

        var isFiltered: Bool {
            let isFiltered: Bool
            switch self {
            case .cityChanged:
                isFiltered = true
            case .manualUpdate, .noAgencySelected:
                isFiltered = false
            }
            return isFiltered
        }

    }

    let mode: AgenciesListViewController.Mode
    var viewModel: AgenciesListViewModel

    // MARK: Views

    var tableView: UITableView! = {
        let tableView = ControlContainableTableView()
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 76
        tableView.register(AgencyCell.self, forCellReuseIdentifier: AgencyCell.rz_reuseID)
        tableView.backgroundColor = .clear
        return tableView
    }()

    var refreshButtonFooterView: UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 64))
        footerView.backgroundColor = .clear

        let button = UIButton(type: .system)
        button.frame = footerView.bounds
        button.tintColor = .white
        button.backgroundColor = .clear
        button.setTitle(UIStrings.commonRefresh.string, for: .normal)
        button.setImage(Asset.icnRefresh.image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)

        button.addTarget(self, action: #selector(AgenciesListViewController.refreshAction), for: .touchUpInside)
        footerView.addSubview(button)

        return footerView
    }

    lazy var otherServiceAreasView: UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 64))
        footerView.backgroundColor = .clear

        let button = TintedButton(backgroundColor: Colors.Common.white, tintColor: Colors.Common.navy)
        button.setTitle(UIStrings.agenciesOtherServiceAreas.string, for: .normal)
        button.titleLabel?.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)

        button.addTarget(self, action: #selector(AgenciesListViewController.refreshAction), for: .touchUpInside)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        footerView.addSubview(button)

        button.centerXAnchor == footerView.centerXAnchor
        button.centerYAnchor == footerView.centerYAnchor
        button.widthAnchor == (footerView.widthAnchor * 0.66) ~ (UILayoutPriorityDefaultHigh - 5)
        button.heightAnchor == footerView.heightAnchor * 0.66

        return footerView
    }()

    lazy var refreshIndicatorFooterView: UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 64))
        footerView.backgroundColor = .clear

        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.startAnimating()
        activity.frame = footerView.bounds
        footerView.addSubview(activity)

        return footerView
    }()

    // this is lazy to allow us to access self.mode.headerText
    private(set) lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow

        let imageView = UIImageView(image: Asset.imgMapBg.image)

        let label = UILabel()
        label.text = self.mode.headerText
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = Colors.Common.white
        label.numberOfLines = 0
        label.widthAnchor == 255
        label.textAlignment = .center
        self.headerLabel = label

        view.addSubview(imageView)
        view.addSubview(label)

        imageView.edgeAnchors == view.edgeAnchors
        label.centerXAnchor == view.centerXAnchor
        label.centerYAnchor == view.centerYAnchor

        return view
    }()

    var headerLabel: UILabel?

    // MARK: Init

    init(viewModel: AgenciesListViewModel, mode: AgenciesListViewController.Mode) {
        self.viewModel = viewModel
        self.mode = mode

        super.init(nibName: nil, bundle: nil)

        navigationItem.title = viewModel.localizedTitle
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UIViewController

    override func loadView() {
        view = UIView()
        view.backgroundColor = Colors.Common.marineBlue
        view.addSubview(headerView)
        view.addSubview(tableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        switch mode {
        case .manualUpdate, .cityChanged:
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                               target: self,
                                                               action: #selector(dismissAgenciesList))
        case .noAgencySelected:
            navigationItem.leftBarButtonItem = nil
        }

        tableView.dataSource = self
        tableView.delegate = self

        // Constraints
        headerView.topAnchor == view.topAnchor
        headerView.horizontalAnchors == view.horizontalAnchors
        tableView.topAnchor == headerView.bottomAnchor - 60
        tableView.horizontalAnchors == view.horizontalAnchors - 4
        tableView.bottomAnchor == view.bottomAnchor

        viewModel.isFiltered = mode.isFiltered
        updateRefreshState(previousStateWasFiltered: mode.isFiltered)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // prevents double prompting if the user changes cities manually
        CityChangePromptManager.userPrompted()
        refresh(previousStateWasFiltered: mode.isFiltered)
    }

    // MARK: Actions

    func refreshAction() {
        refresh(previousStateWasFiltered: false)
    }

    func refresh(previousStateWasFiltered: Bool) {
        per_hideEmptyState()
        viewModel.isFiltered = previousStateWasFiltered
        viewModel.refresh { _ in
            self.updateRefreshState(previousStateWasFiltered: previousStateWasFiltered)
            self.per_updateEmptyState(self.viewModel)
            self.tableView.reloadData()
        }
        updateRefreshState(previousStateWasFiltered: previousStateWasFiltered)
    }

    // MARK: Refresh

    func updateRefreshState(previousStateWasFiltered: Bool) {
        if viewModel.state.isRefreshing {
            tableView.tableFooterView = refreshIndicatorFooterView
            Accessibility.shared.announce(UIStrings.stopsAccessibilityRefreshingTitle(viewModel.localizedTitle).string)
        } else {
            if viewModel.allowsManualRefresh {
                tableView.tableFooterView = previousStateWasFiltered ? otherServiceAreasView : refreshButtonFooterView
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

    func emptyStateContentOffset() -> CGPoint {
        return CGPoint(x: 0, y: -MainViewController.segmentedControlPadding)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // Hiding the changed text for error states to avoid layout issues
    func per_updateEmptyState(_ viewModel: ListViewModel) {
        if let emptyState = viewModel.activeEmptyState {
            headerLabel?.isHidden = true
            per_showEmptyState(emptyState)
        } else {
            headerLabel?.isHidden = false
            per_hideEmptyState()
        }
    }

}

private extension AgenciesListViewController {

    @objc func dismissAgenciesList() {
        dismiss(animated: true, completion: nil)
    }

}

extension AgenciesListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AgencyCell.rz_reuseID, for: indexPath)

        if let cell = cell as? AgencyCell {
            cell.viewModel = viewModel.listObjects[indexPath.row]
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCell(at: indexPath.row)
        dismiss(animated: true, completion: nil)
    }

}
