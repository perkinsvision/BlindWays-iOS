//
//  StopDetailViewController.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 4/1/16.
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

import MessageUI
import Anchorage
import RZUtils

class StopDetailViewController: UIViewController {

    // Public Properties

    let viewModel: StopDetailViewModel

    // Private Properties

    fileprivate let tableView: UITableView = ControlContainableTableView(frame: CGRect.zero, style: .grouped)

    fileprivate let hairline = HairlineView(axis: .horizontal, color: Colors.Common.navy)

    // MARK: Init

    init(viewModel: StopDetailViewModel) {
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
        view.addSubview(tableView)
        view.addSubview(hairline)
    }

    func configureLayout() {
        tableView.edgeAnchors == view.edgeAnchors
        hairline.topAnchor == topLayoutGuide.bottomAnchor
        hairline.horizontalAnchors == horizontalAnchors
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureStyle()
        configureTableView()
        configureLocationMonitoring()
        configureSavedStopsItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
        NotificationCenter.default.addObserver(self, selector: #selector(StopsListViewController.handleAppForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopMonitoringLocation()
        NotificationCenter.default.removeObserver(self)
    }

    func configureStyle() {
        view.backgroundColor = Colors.Common.marineBlue
        tableView.backgroundColor = .clear
        tableView.alpha = 0.0
        hairline.alpha = 0.0
    }

    func refresh() {
        var activity: UIActivityIndicatorView?
        if viewModel.state.isPending {
            activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            activity?.present(in: view, animated: true)
        }

        viewModel.refreshStopDetail {
            self.tableView.reloadData()

            if let text = self.viewModel.localizedRoutesTitle {
                self.tableView.rz_setHeaderText(text)
            }

            activity?.hide(animated: true, animationBlock: {
                self.tableView.alpha = 1.0
                }, completion: nil)

            self.viewModel.refreshArrivals {
                self.tableView.reloadData()
            }
        }
    }

    func configureLocationMonitoring(forceLocationPrompt: Bool = false) {
        viewModel.startMonitoringLocationWithCallback(forceLocationPrompt) { [weak self] in
            guard self?.viewModel.locationItemIndexPath != nil else {
                return
            }

            self?.tableView.reloadData()
        }
    }

    func enableLocationTapped() {
        configureLocationMonitoring(forceLocationPrompt: true)
    }

    // MARK: App Lifecycle

    func handleAppForeground() {
        refresh()
        configureLocationMonitoring()
    }

    // MARK: Saved Stops

    func configureSavedStopsItem(_ animated: Bool = false) {
        let image = viewModel.isSaved ? Asset.icnSaved.image : Asset.icnSave.image
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(StopDetailViewController.toggleSavedStop))
        item.accessibilityLabel = viewModel.isSaved ? UIStrings.stopDetailAccessibilityStopSavedTitle.string : UIStrings.stopDetailAccessibilityStopSaveTitle.string
        item.accessibilityHint = viewModel.isSaved ? UIStrings.stopDetailAccessibilityStopSavedHint.string : UIStrings.stopDetailAccessibilityStopSaveHint.string
        navigationItem.setRightBarButton(item, animated: animated)
    }

    func toggleSavedStop() {
        per_performAuthenticatedAction(UIStrings.stopDetailSaveStopsAccountRequiredMessage.string, client: viewModel.client) { [weak self] in
            self?.authenticatedToggleSavedStop()
        }
    }

    func authenticatedToggleSavedStop() {
        let saved = !self.viewModel.isSaved
        self.viewModel.setSavedStop(saved) { [weak self] in
            self?.configureSavedStopsItem(true)
        }

    }

    // MARK: General Actions

    func arrivalsTapped() {
        let arrivalsVC = BusArrivalsViewController(viewModel: viewModel.arrivalsViewModel)
        navigationController?.pushViewController(arrivalsVC, animated: true)
    }

    func locationTapped() {
        showMap()
    }

    // MARK: Add Clue Actions

    func addEditClueTapped(_ sender: UITableViewCell) {
        showAddClue(tableView.indexPath(for: sender))
    }

    func addClue() {
        showAddClue()
    }

    fileprivate func showDeleteClue(_ indexPath: IndexPath) {
        per_performAuthenticatedAction(UIStrings.stopDetailEditCluesAccountRequiredMessage.string, client: viewModel.client) { [weak self] in
            self?.authenticatedDeleteClue(indexPath)
        }
    }

    fileprivate func showAddClue(_ indexPath: IndexPath? = nil) {
        per_performAuthenticatedAction(UIStrings.stopDetailEditCluesAccountRequiredMessage.string, client: viewModel.client) { [weak self] in
            self?.authenticatedShowAddClue(indexPath)
        }
    }

    fileprivate func authenticatedDeleteClue(_ indexPath: IndexPath) {
        guard let editClueSetViewModel = viewModel.editClueSetViewModel else {
            return
        }

        let clues: [EditClueViewModel] = {
            let clues = editClueSetViewModel.cluesAsList()
            if let orientation = viewModel.clueSetViewModel?.orientation, orientation == .streetOnRight {
                return clues.reversed()
            } else {
                return clues
            }
        }()
        let editClueViewModel = clues[indexPath.row]

        // Set the clue type to nil, which effectively deletes the clue
        editClueViewModel.type = nil

        let dismissActivity = rz_showActivityIndicator(in: view, animated: true)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false

        editClueSetViewModel.updateClueSet { result in
            dismissActivity(nil)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationItem.leftBarButtonItem?.isEnabled = true

            if !result.isSuccess {
                self.rz_alert(UIStrings.commonProblem.string, message: UIStrings.stopDetailDeleteClueSaveErrorMessage.string)
            }

            if Accessibility.isVoiceOverRunning() {
                Accessibility.shared.announce(UIStrings.stopDetailDeleteClueAccessibilitySuccessMessage.string, completion: { _, _ in
                    self.refresh()
                })
            } else {
                self.refresh()
            }

        }
    }

    fileprivate func authenticatedShowAddClue(_ indexPath: IndexPath? = nil) {
        if let editClueSetViewModel = viewModel.editClueSetViewModel, let clueSetViewModel = viewModel.clueSetViewModel {
            if let indexPath = indexPath {
                editClueSetViewModel.preselectedSlotIndex = clueSetViewModel.clueIndex(fromIndexInTableView: indexPath.row)
            }
            let nav: UINavigationController

            let editingDismissalHandler: ((_ dismissalCompletion: Block?) -> Void) = { [weak self] (dismissalCompletion: Block?) in
                self?.dismiss(animated: true, completion: { dismissalCompletion?() })
            }

            if GeoLocator.authorizationStatus == .yes && viewModel.userIsInVicinityOfStop {
                let captureVC = CaptureStopLocationViewController(viewModel: editClueSetViewModel, editingDismissalHandler: editingDismissalHandler)
                nav = UINavigationController(rootViewController: captureVC)
            } else {
                let cluesVC = EditCluesViewController(viewModel: editClueSetViewModel, editingDismissalHandler: editingDismissalHandler)
                nav = UINavigationController(rootViewController: cluesVC)
            }

            present(nav, animated: true, completion: nil)
        }
    }

    // MARK: Clue Actions

    func moreActionsTapped(_ sender: UITableViewCell) {
        if let clue = clue(for: sender), let indexPath = tableView.indexPath(for: sender) {
            showMoreActionsForClue(clue, indexPath: indexPath)
        }
    }

    func reportProblemTapped(_ sender: UITableViewCell) {
        if let clue = clue(for: sender) {
            self.reportProblemForClue(clue)
        }
    }

    func confirmClueTapped(_ sender: UITableViewCell) {
        if let clue = clue(for: sender) {
            confirmClue(clue)
        }
    }

    func deleteClueTapped(_ sender: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            self.showDeleteClueConfirmAlert(indexPath)
        }
    }

    func clueCellBecameFocusedAccessibilityElement(_ sender: UITableViewCell) {
        viewModel.trackClueUsage()
    }

    fileprivate func confirmClue(_ clueViewModel: ClueViewModel) {
        self.viewModel.confirmClue(clueViewModel, completion: {
            self.rz_alert(UIStrings.stopDetailClueActionsThanksTitle.string, message: UIStrings.stopDetailClueActionsConfirmThanksMessage.string)
            self.refresh()
        })
    }

    fileprivate func showMoreActionsForClue(_ clueViewModel: ClueViewModel, indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if viewModel.userIsInVicinityOfStop {
            alert.addAction(UIAlertAction(title: UIStrings.stopDetailClueActionsDeleteClueTitle.string, style: .destructive, handler: { _ in
                self.showDeleteClueConfirmAlert(indexPath)
            }))
        }

        if User.loggedInUser != nil && !clueViewModel.confirmed {
            alert.addAction(UIAlertAction(title: UIStrings.stopDetailClueActionsConfirmTitle.string, style: .default, handler: { _ in
                self.confirmClue(clueViewModel)
            }))
        }

        alert.addAction(UIAlertAction(title: UIStrings.stopDetailClueActionsEditClueTitle.string, style: .default, handler: { _ in
            self.showAddClue(indexPath)
        }))

        alert.addAction(UIAlertAction(title: UIStrings.stopDetailClueActionsReportProblemTitle.string, style: .default, handler: { _ in
            self.reportProblemForClue(clueViewModel)
        }))

        alert.addAction(UIAlertAction(title: UIStrings.commonCancel.string, style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    fileprivate func showDeleteClueConfirmAlert(_ indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: UIStrings.stopDetailClueActionsDeleteClueTitle.string, style: .destructive, handler: { _ in
            self.showDeleteClue(indexPath)
        }))

        alert.addAction(UIAlertAction(title: UIStrings.commonCancel.string, style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    // MARK: Action Helpers

    fileprivate func clue(for cell: UITableViewCell) -> ClueViewModel? {
        if let indexPath = tableView.indexPath(for: cell) {
            switch viewModel.sections[indexPath.section] {
            case .clues(let clues):
                return clues[indexPath.row]
            default: break
            }
        }

        return nil
    }

    func changeClueDirection() {
        if let clueSetViewModel = viewModel.clueSetViewModel {
            clueSetViewModel.orientation = clueSetViewModel.orientation == .streetOnLeft ? .streetOnRight : .streetOnLeft
            tableView.reloadData()
        }
    }

    var cluesSectionIndex: Int {
        for (index, section) in viewModel.sections.enumerated() {
            switch section {
            case .clues: return index
            default: continue
            }
        }

        return -1
    }

}

extension StopDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func configureTableView() {
        tableView.alpha = 0.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 84

        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 84

        tableView.sectionFooterHeight = 0
        tableView.estimatedSectionFooterHeight = 0

        tableView.register(InfoItemCell.self, forCellReuseIdentifier: InfoItemCell.rz_reuseID)
        tableView.register(ClueCell.self, forCellReuseIdentifier: ClueCell.rz_reuseID)
        tableView.register(EmptyStateHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: EmptyStateHeaderFooterView.reuseID)
        tableView.register(ClueDirectionHeaderView.self, forHeaderFooterViewReuseIdentifier: ClueDirectionHeaderView.reuseID)
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch viewModel.sections[indexPath.section] {
        case .info(let rows):
            let row = rows[indexPath.row]
            switch row.infoItem {
            case is StopDetailArrivalViewModel:
                return row.infoItem.hasChildren ? indexPath : nil
            case is LocationViewModel:
                return indexPath
            default:
                preconditionFailure("Unexpected info item: \(row.infoItem)")
            }
        case .clues(let clues):
            let clueViewModel = clues[indexPath.row]
            if clueViewModel.clue == nil {
                return indexPath
            } else {
                return nil
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].numberOfRows
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ClueCell {
            let numRows = tableView.numberOfRows(inSection: indexPath.section)
            cell.separatorView.isHidden = numRows == indexPath.row + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.sections[indexPath.section] {
        case .info(let rows):
            let row = rows[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: InfoItemCell.rz_reuseID, for: indexPath) as? InfoItemCell {
                cell.viewModel = row.infoItem
                cell.accessibilityTraits = UIAccessibilityTraitNone

                if row.infoItem is LocationViewModel {
                    cell.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently
                }

                if row.infoItem.hasChildren {
                    cell.accessibilityTraits = cell.accessibilityTraits | UIAccessibilityTraitButton
                }

                return cell
            }
        case .clues(let clues):
            let clue = clues[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: ClueCell.rz_reuseID, for: indexPath) as? ClueCell {
                cell.viewModel = clue
                cell.stopDetailViewModel = viewModel
                return cell
            }
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.sections[indexPath.section] {
        case .info(let rows):
            let row = rows[indexPath.row]
            if let action = row.action {
                UIApplication.shared.sendAction(action, to: nil, from: self, for: nil)
            }
        case .clues(let clues):
            let clueViewModel = clues[indexPath.row]
            if clueViewModel.clue == nil {
                showAddClue(indexPath)
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.sections[section] {
        case .clues:
            if let emptyState = viewModel.noCluesEmptyState {
                return emptyStateView(emptyState)
            } else {
                return clueHeaderView()
            }
        default: break
        }

        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.sections[section] {
        case .clues: return UITableViewAutomaticDimension
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }

    func clueHeaderView() -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ClueDirectionHeaderView.reuseID) as? ClueDirectionHeaderView {
            headerView.viewModel = viewModel.clueSetViewModel
            return headerView
        } else {
            return nil
        }
    }

    func emptyStateView(_ emptyState: EmptyState) -> UIView? {
        if let emptyStateHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: EmptyStateHeaderFooterView.reuseID) as? EmptyStateHeaderFooterView {
            emptyStateHeader.emptyState = emptyState

            // ??? - Calculate the remaining space between the last cell and the end of the view
            // in order to fill the available space with the empty state view.
            let section = cluesSectionIndex - 1
            let row = tableView.numberOfRows(inSection: section) - 1
            let indexPath = IndexPath(row: row, section: section)
            if let cell = tableView.cellForRow(at: indexPath) {
                let rect = view.convert(cell.frame, to: view)
                let maxHeight: CGFloat = (view.bounds.size.height - rect.maxY) + view.frame.origin.y + 20
                emptyStateHeader.heightConstraint.constant = maxHeight
                emptyStateHeader.widthConstraint.constant = tableView.bounds.size.width
            }

            return emptyStateHeader
        } else {
            return nil
        }
    }

}

extension StopDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let hairlineAlpha = offsetY.scaled(from: 0.0...6.0, to: 0.0...1.0)
        hairline.alpha = hairlineAlpha
    }

}

extension StopDetailViewController: LocationInfoActions {

    func getDirectionsTapped() {
        NavigationService.requestNavigation(
            to: viewModel.stopViewModel.stop.location,
            placeName: viewModel.stopViewModel.stop.name,
            inViewController: self)
    }

    func showMapTapped() {
        showMap()
    }

}

private extension StopDetailViewController {

    func showMap() {
        let mapViewModel = viewModel.mapViewModel
        let mapViewController = MapViewController(viewModel: mapViewModel)
        navigationController?.pushViewController(mapViewController, animated: true)
    }

}

extension StopDetailViewController: MFMailComposeViewControllerDelegate {

    func reportProblemForClue(_ clueViewModel: ClueViewModel) {
        if let clue = clueViewModel.clue as? Clue {

            // These shenenagans are in place to ensure the nav bar looks decent.
            // As of iOS 9.3, MFMailComposeViewController doesn't respect all appearance proxy settings
            // Radar 26702514
            let navBarStyle = RZNavBarStyle.saveAppearanceState()
            RZNavBarStyle.clearAppearanceState()

            let mailVC = RZAboutMailController()
            mailVC.savedNavBarStyle = navBarStyle
            mailVC.navigationBar.tintColor = Colors.Common.marineBlue

            mailVC.setToRecipients([ AppConstants.Emails.reportProblem ])
            mailVC.setSubject("[Perkins App] Problem with Clue: \(clue.remoteID) at Stop: \(viewModel.stopViewModel.stop.name) - \(viewModel.stopViewModel.stop.remoteID)")
            mailVC.mailComposeDelegate = self
            present(mailVC, animated: true, completion: nil)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == MFMailComposeResult.sent {
            rz_alert(UIStrings.stopDetailClueActionsThanksTitle.string, message: UIStrings.stopDetailClueActionsReportProblemThanksMessage.string)
        }

        controller.dismiss(animated: true, completion: nil)
    }

}
