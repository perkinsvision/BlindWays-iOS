//
//  MainViewController.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/9/16.
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

class MainViewController: UIViewController {

    static let segmentedControlPadding: CGFloat = 18.0

    let viewModel: MainViewModel
    var viewControllers: [StopsListViewController] = [StopsListViewController]()
    var activeViewController: StopsListViewController?

    var segmentedControl: UISegmentedControl!
    var containerView: UIView!

    // MARK: Init

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        navigationItem.title = UIStrings.stopsTitle.string
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: UIStrings.settingsTitle.string, style: .plain, target: self, action: #selector(MainViewController.settingsTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(MainViewController.searchTapped))
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)

        segmentedControl = UISegmentedControl(items: viewModel.listViewModels.map({ $0.localizedTitle }))
        view.addSubview(segmentedControl)

        containerView = UIView()
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
    }

    func configureLayout() {
        segmentedControl.topAnchor == topLayoutGuide.bottomAnchor + 8
        segmentedControl.horizontalAnchors == view.horizontalAnchors + 34

        containerView.topAnchor == segmentedControl.bottomAnchor + MainViewController.segmentedControlPadding
        containerView.leadingAnchor == view.leadingAnchor
        containerView.trailingAnchor == view.trailingAnchor
        containerView.bottomAnchor == view.bottomAnchor
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureStyle()

        configureSegmentedControl()
        segmentedControl.selectedSegmentIndex = 0
        segmentChanged()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if viewModel.shouldShowAgencies {
            let agenciesListViewController = AgenciesListViewController(viewModel: viewModel.agenciesListViewModel, mode: .noAgencySelected)
            present(UINavigationController(rootViewController: agenciesListViewController), animated: true, completion: nil)
        }
    }

    // MARK: Segmented Control

    func configureSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(MainViewController.segmentChanged), for: .valueChanged)

        for viewModel in self.viewModel.listViewModels {
            viewControllers.append(StopsListViewController(viewModel: viewModel))
        }
    }

    func segmentChanged() {
        if let active = activeViewController {
            self.rz_removeChildViewController(active)
        }

        let viewController = viewControllers[segmentedControl.selectedSegmentIndex]
        self.rz_addChildViewController(viewController, inView: containerView) { view in
            view.edgeAnchors == self.containerView.edgeAnchors
        }
        activeViewController = viewController
        navigationItem.backBarButtonItem = UIBarButtonItem(title: viewController.viewModel.backButtonTitle, style: .plain, target: nil, action: nil)
    }

    // MARK: Style

    func configureStyle() {
        view.backgroundColor = Colors.Common.marineBlue
    }

    // MARK: Actions

    func searchTapped() {
        let searchVC = RouteSearchViewController(viewModel: viewModel.routeSearchViewModel)
        let nav = UINavigationController(rootViewController: searchVC)
        present(nav, animated: true, completion: nil)
    }

    func settingsTapped() {
        let viewModel = SettingsViewModel(client: self.viewModel.client)
        let settingsVC = SettingsViewController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: settingsVC)
        present(nav, animated: true, completion: nil)
    }

}
