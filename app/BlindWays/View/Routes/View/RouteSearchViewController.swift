//
//  RouteSearchViewController.swift
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

import BonMot
import Anchorage

class RouteSearchViewController: UITableViewController {

    let viewModel: RouteSearchViewModel

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.placeholder = UIStrings.routesSearchPlaceholderTitle.string
        searchBar.keyboardType = UIKeyboardType.numbersAndPunctuation
        return searchBar
    }()

    let emptyState: (stackView: UIStackView, messageLabel: UILabel) = {
        let messageLabel = UILabel("messageLabel")
        messageLabel.numberOfLines = 0

        let font = UIFont.dynamicSize(style: .callout, weight: .regular)
        let subtitleLabel = UILabel("noResultsLabel")
        subtitleLabel.attributedText = UIStrings.routesSearchNoResultsSubtitle.string.styled(
            with:
            .color(Colors.Common.gray),
            .font(font),
            .alignment(.center))
        subtitleLabel.numberOfLines = 0

        let stackView = UIStackView(axis: .vertical, identifier: "noResultsStackView", arrangedSubviews: [
            messageLabel,
            subtitleLabel,
            ])
        stackView.spacing = font.pointSize / 1.6

        return (stackView: stackView, messageLabel: messageLabel)
    }()

    // MARK: Init

    init(viewModel: RouteSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: UIStrings.routesSearchBackButtonTitle.string, style: .plain, target: nil, action: nil)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    override func loadView() {
        tableView = ControlContainableTableView(frame: UIScreen.main.bounds)
        tableView.addSubview(emptyState.stackView)
        tableView.keyboardDismissMode = .onDrag
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearch()
        configureStyle()

        let keyboardCenteringGuide = UILayoutGuide("keyboardGuide")
        view.addLayoutGuide(keyboardCenteringGuide)
        keyboardCenteringGuide.topAnchor == topLayoutGuide.bottomAnchor
        keyboardCenteringGuide.horizontalAnchors == view.horizontalAnchors

        let keyboardGuide = view.addKeyboardLayoutGuide()
        keyboardCenteringGuide.bottomAnchor == keyboardGuide.topAnchor

        emptyState.stackView.centerYAnchor == keyboardCenteringGuide.centerYAnchor
        emptyState.stackView.horizontalAnchors == view.layoutMarginsGuide.horizontalAnchors

        updateRefreshState()

        viewModel.stateDidChangeHandler = { [weak self] state in
            self?.updateRefreshState()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        smoothlyDeselectItems(tableView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }

    func configureStyle() {
        // ???: Search bar tintColor must be white in order to have cancel button visible, so we must resort
        // to this hackary in order to set the cursor color properly.
        searchBar.subviews[0].subviews.flatMap { $0 as? UITextField }.first?.tintColor = Colors.Common.marineBlue
    }

    func configureSearch() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
}

extension RouteSearchViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, searchText.characters.count > 0 {
            viewModel.searchText = searchText.trimmingCharacters(in: CharacterSet.whitespaces)

            let dismissActivity = rz_showActivityIndicator(in: tableView, animated: false, adjustPositionForKeyboard: true)

            viewModel.refresh({ _ in
                dismissActivity(nil)
                self.tableView.contentOffset = .zero
                self.updateRefreshState()
            })
            updateRefreshState()
        }
    }
}

extension RouteSearchViewController {

    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = 60
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.state.isLoaded ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell
        if let existingCell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.rz_reuseID) {
            cell = existingCell
        } else {
            // Creating a new cell manually, rather than using cell registration,
            // so that we can use the `UITableViewCell` initializer that takes
            // a `style` parameter.
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: UITableViewCell.rz_reuseID)
            cell.accessoryType = .disclosureIndicator
        }

        let routeViewModel = viewModel.listObjects[indexPath.row]
        cell.textLabel?.text = routeViewModel.localizedTitle
        cell.detailTextLabel?.text = routeViewModel.localizedSubtitle
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let routeStopsViewModel = viewModel.routeStopsViewModel(for: indexPath.row)
        let stopsVC = StopsListViewController(viewModel: routeStopsViewModel)
        navigationController?.pushViewController(stopsVC, animated: true)
    }

    // MARK: Refresh

    func updateRefreshState() {
        tableView.reloadData()
        let noResults = (viewModel.state.isLoaded && viewModel.listObjects.isEmpty)
        emptyState.stackView.isHidden = !noResults
        if noResults {
            let searchedString = searchBar.text?.truncatedSubstring(maxLength: 10) ?? ""
            let font = UIFont.dynamicSize(style: .title2, weight: .semibold)

            let fullStyle = StringStyle(
                .color(Colors.Common.gray),
                .font(font),
                .alignment(.center),
                .xmlRules([
                    .style("tightKerning", StringStyle(.tracking(.point(font.pointSize * -0.2)))),
                    ])
            )

            emptyState.messageLabel.attributedText = UIStrings.routesSearchNoResultsMessage(searchedString).string.styled(with: fullStyle)

            // The period and curl quote, possibly coupled with attributed string stuff,
            // cause VoiceOver to say some extra stuff, so we set the accessibility label
            // to a simplified version of the string. Comment this line and have VoiceOver
            // read the messageLabel if you want to experience the problem.
            emptyState.messageLabel.accessibilityLabel = UIStrings.routesSearchNoResultsAccessibilityMessage(searchedString).string
        }

        if viewModel.state.isRefreshing {
            Accessibility.shared.announce(UIStrings.routesAccessibilitySearchingTitle.string)
        } else {
            Accessibility.shared.announce(UIStrings.routesAccessibilityDidSearchTitle(viewModel.listObjects.count).string) { (_, success) in
                if success {
                    self.tableView.rz_accessibilityFocusOnFirstCell()
                }
            }

        }
    }

}
