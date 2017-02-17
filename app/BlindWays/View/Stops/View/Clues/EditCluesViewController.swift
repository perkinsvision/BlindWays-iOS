//
//  EditCluesViewController.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 4/25/16.
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

final class EditCluesViewController: UIViewController {

    // Public Properties

    static let unhighlightNextClueButtonNotificationName = "\(EditCluesViewController.self).unhighlightNextClueButton"

    // Private Properties

    fileprivate let viewModel: EditClueSetViewModel
    fileprivate let editingDismissalHandler: ((_ dismissalCompletion: Block?) -> Void)
    fileprivate let preselectedSlotIndex: Int?

    fileprivate lazy var tableView: UITableView = {
        let tableView = ControlContainableTableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = Colors.Common.white

        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 80
        tableView.register(EditCluesSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: EditCluesSectionHeaderView.reuseID)
        tableView.register(GroupdSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: GroupdSectionHeaderView.reuseID)

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(ClueTypeCell.self, forCellReuseIdentifier: ClueTypeCell.rz_reuseID)
        tableView.register(EditClueBoolCell.self, forCellReuseIdentifier: EditClueBoolCell.rz_reuseID)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.tableHeaderView = self.tableHeaderView

        return tableView
    }()

    fileprivate let hairline = HairlineView(axis: .horizontal, color: Colors.Common.grayAlt)

    fileprivate lazy var tableHeaderView: EditCluesTableHeaderView = self.createTableHeaderView()

    fileprivate lazy var nextClueButton: UIButton = {
        let button = SolidColorButton(titleColor: Colors.Common.white, backgroundColor: Colors.Common.darkGrassGreen)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.addTarget(self, action: #selector(EditCluesViewController.nextButtonTapped), for: .touchUpInside)
        return button
    }()

    fileprivate var hasPendingChanges: Bool = false
    fileprivate var lastSelectedIndex: Int = ClueSlot.busStopSign.rawValue
    fileprivate var onScrollToTopBlock: Block?

    // MARK: Init

    init(viewModel: EditClueSetViewModel, editingDismissalHandler: @escaping ((_ dismissalCompletion: Block?) -> Void)) {
        self.viewModel = viewModel
        self.editingDismissalHandler = editingDismissalHandler
        self.preselectedSlotIndex = viewModel.preselectedSlotIndex
        super.init(nibName: nil, bundle: nil)

        self.navigationItem.title = ""
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: UIStrings.commonClose.string, style: .plain, target: self, action: #selector(EditCluesViewController.closeTapped))
        refreshNextButtonState()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(EditCluesViewController.externalRequestToUnhighlightNextClueButton),
            name: Notification.Name(EditCluesViewController.unhighlightNextClueButtonNotificationName),
            object: nil)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = Colors.Common.white

        view.addSubview(tableView)
        view.addSubview(hairline)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        preselectHeaderIndex()
        hairline.alpha = 0.0
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableHeaderView.widthAnchor == tableView.bounds.size.width
        tableHeaderView.layoutIfNeeded()
        tableView.tableHeaderView = tableHeaderView

        // Need to reset the table footer view after setting its frame, so just do this every time.
        nextClueButton.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 56))
        tableView.tableFooterView = nextClueButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = navigationController {
            if nav.isNavigationBarHidden {
                nav.setNavigationBarHidden(false, animated: animated)
            }
            Appearance.styleNavBar(nav.navigationBar, color: Colors.Common.white)
            nav.navigationBar.barStyle = .default
            nav.navigationBar.tintColor = Colors.Common.black

            navigationItem.titleView = {
                let label = UILabel("EditCluesViewController_TitleView")
                label.font = UIFont.preferredFont(forTextStyle: .headline)
                label.rz_setTextPronounceable(viewModel.localizedTitle)
                label.textColor = Colors.Common.darkGrassGreen
                label.textAlignment = .center
                label.numberOfLines = 2
                label.adjustsFontSizeToFitWidth = true
                label.minimumScaleFactor = 0.5
                label.sizeToFit()
                return label
            }()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if Accessibility.isVoiceOverRunning() {
            self.voiceOverFocusOnHeader(delay: 0.1, hideFirstCell: true)
        }

        refreshClueListState()
        tableHeaderView.triggerIntroIfNeeded()
    }

}

extension EditCluesViewController: EditClueBoolCellActions {

    func switchChanged(_ sender: EditClueBoolCell) {
        hasPendingChanges = true
    }

}

extension EditCluesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedClueViewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedClueViewModel.sections[section] {
        case .clueTypes(let clueTypes): return clueTypes.count
        case .placement(let fields): return fields.count
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch selectedClueViewModel.sections[indexPath.section] {
        case .clueTypes(_):
            if let cell = cell as? ClueTypeCell {
                if cell.isSelected {
                    selectRowForSelectedClueType(cell)
                }
            }
        case .placement: break
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedClueViewModel.sections[indexPath.section] {
        case .clueTypes(let clueTypes):
            if let cell = tableView.dequeueReusableCell(withIdentifier: ClueTypeCell.rz_reuseID) as? ClueTypeCell {
                let clueType = clueTypes[indexPath.row]
                cell.clueType = clueType
                return cell
            }
        case .placement(let fields):
            if let cell = tableView.dequeueReusableCell(withIdentifier: EditClueBoolCell.rz_reuseID) as? EditClueBoolCell {
                cell.field = fields[indexPath.row]
                return cell
            }
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at: indexPath, animated: false)
            selectedClueViewModel.type = nil
            refreshTableHeaderState()
            refreshNextButtonState()
            hasPendingChanges = true
            return nil
        }

        switch selectedClueViewModel.sections[indexPath.section] {
        case .clueTypes(let clueTypes):
            let clueType = clueTypes[indexPath.row]
            if clueType.isOtherType {
                selectOtherType(clueType)
                return nil
            } else if clueType.subTypes != nil {
                selectMultiClueType(clueType)
                return nil
            }
        case .placement(_):
            return nil
        }

        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedClueViewModel.sections[indexPath.section] {
        case .clueTypes(let clueTypes):
            let clueType = clueTypes[indexPath.row]
            selectSingleClueType(clueType)
        default: break
        }

    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionEnum = selectedClueViewModel.sections[section]
        switch sectionEnum {
        case .clueTypes(_):
            if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: EditCluesSectionHeaderView.reuseID) as? EditCluesSectionHeaderView {
                view.viewModel = selectedClueViewModel
                return view
            }
        case .placement(_):
            if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: GroupdSectionHeaderView.reuseID) as? GroupdSectionHeaderView {
                view.title = sectionEnum.sectionTitle
                return view
            }
        }

        return nil
    }

    // MARK: Scroll View

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // ??? - Programatic setContentOffset doesn't always seem to bring us to the desired 0,0 offset.
        if let block = onScrollToTopBlock, isScrollPositionTop {
            block()
            onScrollToTopBlock = nil
        }

        let offsetY = tableView.contentOffset.y

        let signVisible = offsetY < nextClueTopOffsetY
        tableHeaderView.setSignVisible(signVisible)

        let hairlineAlpha = offsetY.scaled(from: 0.0...13.0, to: 0.0...1.0)
        hairline.alpha = hairlineAlpha
    }

}

private extension EditCluesViewController {

    func configureLayout() {
        tableView.leadingAnchor == view.leadingAnchor
        tableView.trailingAnchor == view.trailingAnchor
        tableView.topAnchor == view.topAnchor
        tableView.bottomAnchor == view.bottomAnchor

        hairline.topAnchor == topLayoutGuide.bottomAnchor
        hairline.horizontalAnchors == horizontalAnchors
    }

    func unhighlightNextClueButton() {
        // For unknown reasons, the button sometimes stays highlighted after tapping it
        // for the first time. Make sure it gets unhighlighted when resetting it.
        nextClueButton.isHighlighted = false
    }

    @objc func externalRequestToUnhighlightNextClueButton() {
        // Because we are not resending the review screen full-screen,
        // we don't get view{Will/Did}Appear when popping back here.
        // To work around that, EditCluesReviewViewController posts
        // a notification whne it is about to dismiss, and we handle
        // that notification here and clean up the Next Clue button,
        // which sometimes gets stuck in a highlighted state.
        unhighlightNextClueButton()
    }

    // MARK: Actions

    @objc func closeTapped() {
        if hasPendingChanges {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: UIStrings.stopDetailEditCluesetUnsavedChangesDiscardTitle.string, style: .destructive, handler: { _ in
                self.editingDismissalHandler(nil)
            }))
            alert.addAction(UIAlertAction(title: UIStrings.stopDetailEditCluesetUnsavedChangesSaveTitle.string, style: .default, handler: { _ in
                self.doneTapped()
            }))
            alert.addAction(UIAlertAction(title: UIStrings.commonCancel.string, style: .cancel, handler: nil))

            present(alert, animated: true, completion: nil)
        } else {
            editingDismissalHandler(nil)
        }
    }

    @objc func doneTapped() {
        guard hasPendingChanges else {
            closeTapped()
            return
        }

        let reviewViewModel = ReviewCluesViewModel(viewModel: viewModel)
        let reviewVC = EditCluesReviewViewController(
            viewModel: reviewViewModel,
            reviewCompletion: { result in
                switch result {
                case .edit(let slotIndex):
                    self.tableHeaderView.clueSlotControl.selectSlot(at: slotIndex, animated: false, notifyAction: false)
                    self.refreshClueListState(animated: false)
                    self.tableView.setContentOffset(CGPoint(x: 0, y: self.nextClueTopOffsetY), animated: false)
                case .cancel: break
                }
            },
            editingDismissalHandler: editingDismissalHandler)
        let nav = UINavigationController(rootViewController: reviewVC)
        nav.modalPresentationStyle = .overCurrentContext
        present(nav, animated: true, completion: nil)
    }

    // MARK: Clues

    @objc func handleSlotChange() {
        refreshClueListState()
        unhighlightNextClueButton()
    }

    func refreshClueListState(animated: Bool = true) {
        reloadClues(animated: animated)
        refreshTableHeaderState()
        refreshNextButtonState()
    }

    var selectedClueViewModel: EditClueViewModel {
        return viewModel.clueViewModels[tableHeaderView.clueSlotControl.selectedIndex]
    }

    @objc func nextButtonTapped() {
        if isNextButtonStateDone {
            doneTapped()
        } else if let nextSlot = viewModel.nextUnfilledSlot(from: selectedClueViewModel.clueSlot) {
            if isScrollPositionTop {
                tableHeaderView.clueSlotControl.selectSlot(at: nextSlot.rawValue)
            } else {
                onScrollToTopBlock = { [weak self] in
                    self?.tableHeaderView.clueSlotControl.selectSlot(at: nextSlot.rawValue)
                }
                tableView.setContentOffset(CGPoint(x: 0, y: nextClueTopOffsetY), animated: true)
            }

        }
    }

    var isNextButtonStateDone: Bool {
        if let nextSlot = viewModel.nextUnfilledSlot(from: selectedClueViewModel.clueSlot) {
            if nextSlot == .farRight && selectedClueViewModel.clueSlot == .farRight {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }

    func reloadClues(animated: Bool) {
        let selectedIndex = tableHeaderView.clueSlotControl.selectedIndex
        let lastSelectedIndex = self.lastSelectedIndex
        if selectedIndex == lastSelectedIndex {
            selectRowForSelectedClueType()
            return
        } else {
            // Auto-sizing cells result in the cell being measured before its view model
            // is updated. To work around this, set the new view model immediately,
            // before asking the table view to update.
            if let headerView = editCluesSectionHeaderView() {
                headerView.viewModel = selectedClueViewModel
            }

            let onReloadCompletion = {
                self.voiceOverFocusOnHeader()
            }

            let changesBlock = {
                self.tableView.reloadData()
                self.selectRowForSelectedClueType()
            }

            if animated {
                if selectedIndex > lastSelectedIndex {
                    tableView.rz_performChangesUsingSlideAnimation(direction: .left, changes: changesBlock, completion: onReloadCompletion)
                } else {
                    tableView.rz_performChangesUsingSlideAnimation(direction: .right, changes: changesBlock, completion: onReloadCompletion)
                }
            } else {
                changesBlock()
                onReloadCompletion()
            }
        }

        self.lastSelectedIndex = selectedIndex
    }

    // MARK: Header

    func createTableHeaderView() -> EditCluesTableHeaderView {
        let view = EditCluesTableHeaderView()
        view.viewModel = self.viewModel
        view.clueSlotControl.addTarget(self, action: #selector(EditCluesViewController.handleSlotChange), for: .valueChanged)
        return view
    }

    func preselectHeaderIndex() {
        if let index = self.preselectedSlotIndex {
            lastSelectedIndex = index
            tableHeaderView.clueSlotControl.selectSlot(at: index, animated: false)
        }
    }

    func refreshTableHeaderState() {
        tableHeaderView.viewModel = viewModel
    }

    func editCluesSectionHeaderView() -> EditCluesSectionHeaderView? {
        guard let clueTypeSection = selectedClueViewModel.sections.index(where: { section in
            switch section {
            case .clueTypes: return true
            default: return false
            }
        }) else {
            return nil
        }

        return tableView.headerView(forSection: clueTypeSection) as? EditCluesSectionHeaderView
    }

    // MARK: Clue Type Selection

    func selectMultiClueType(_ clueType: ClueType) {
        guard let subTypes = clueType.subTypes else {
            return
        }

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for type in subTypes {
            alert.addAction(UIAlertAction(title: type.title, style: .default, handler: { (_) in
                self.userSelectType(type.type, voiceOverDelay: 1.0)
            }))
        }

        alert.addAction(UIAlertAction(title: UIStrings.commonCancel.string, style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    func selectSingleClueType(_ clueType: ClueType) {
        userSelectType(clueType.type)
    }

    func selectOtherType(_ clueType: ClueType) {
        let alert = UIAlertController(title: UIStrings.stopDetailEditCluesetOtherAlertTitle.string, message: UIStrings.stopDetailEditCluesetOtherAlertMessage.string, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UIStrings.commonOk.string, style: .default, handler: { _ in
            if let fields = alert.textFields, let text = fields[0].text, text.characters.count > 0 {
                self.userSelectType(clueType.type, hint: text, voiceOverDelay: 1.0)
            }
        }))
        alert.addAction(UIAlertAction(title: UIStrings.commonCancel.string, style: .cancel, handler: nil))

        alert.addTextField { (textField) in
            textField.placeholder = UIStrings.stopDetailEditCluesetOtherAlertPlaceholder.string
        }

        present(alert, animated: true, completion: nil)
    }

    func userSelectType(_ type: String, hint: String? = nil, voiceOverDelay: TimeInterval? = nil) {
        selectedClueViewModel.type = type
        selectedClueViewModel.hint = hint
        refreshClueListState()
        hasPendingChanges = true
        if let delay = voiceOverDelay {
            voiceOverFocusOnNextButton(delay: delay)
        } else {
            voiceOverFocusOnNextButton()
        }
    }

    func selectRowForSelectedClueType(_ existingCell: ClueTypeCell? = nil) {
        if let selectedType = selectedClueViewModel.type {
            for (index, clueType) in selectedClueViewModel.clueTypes.enumerated() {
                if let matchingType = clueType.matchingSubType(selectedType) {

                    // ??? - If we are provided with a cell, method is being called from willDisplayCell
                    // and is already selected, so use it. Otherwise, get the cell and select the row
                    var loadedCell: ClueTypeCell?
                    if let existingCell = existingCell {
                        loadedCell = existingCell
                    } else {
                        let indexPath = IndexPath(row: index, section: 0)
                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                        loadedCell = tableView.cellForRow(at: indexPath) as? ClueTypeCell
                    }

                    guard let cell = loadedCell else {
                        return
                    }

                    if let hint = selectedClueViewModel.hint {
                        if clueType.isOtherType {
                            cell.detailLabel.text = hint
                        }
                    } else if clueType.type != selectedType {
                        // Sub-type is selected
                        cell.detailLabel.text = matchingType.title
                    }

                    break
                }
            }
        }
    }

    var isScrollPositionTop: Bool {
        // Check +3 because sometimes UITableView does not report offset as 0 when it should
        return tableView.contentOffset.y < nextClueTopOffsetY + 3
    }

    var nextClueTopOffsetY: CGFloat {
        return tableHeaderView.bounds.height - tableHeaderView.clueSlotControl.bounds.height
    }

    // MARK: Accessibility

    func voiceOverFocusOnHeader(delay: TimeInterval = 0.1, hideFirstCell: Bool = false) {
        if let headerView = editCluesSectionHeaderView() {
            Utility.performAfter(delay) {
                Accessibility.shared.layoutChanged(focusView: headerView)
            }

            if let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ClueTypeCell, hideFirstCell {
                firstCell.temporarilyDisableAccessibility(delay: delay)
            }
        }
    }

    func voiceOverFocusOnNextButton(delay: TimeInterval = 0.75) {
        Utility.performAfter(delay) {
            Accessibility.shared.layoutChanged(focusView: self.nextClueButton)
        }
    }

}

private extension EditCluesViewController {

    typealias NextButtonTitles = (long: UIStrings, short: UIStrings)

    func nextTitles() -> NextButtonTitles {
        if isNextButtonStateDone {
            return (.commonDone, .commonDone)
        } else {
            if selectedClueViewModel.type != nil {
                return (long: .stopDetailEditCluesetNextClueLong, short: .stopDetailEditCluesetNextClueShort)
            } else {
                return (long: .stopDetailEditCluesetSkipClueLong, short: .stopDetailEditCluesetSkipClueShort)
            }
        }
    }

    func allPossibleShortButtonTitles() -> Set<String> {
        return [
            UIStrings.stopDetailEditCluesetNextClueShort.string,
            UIStrings.stopDetailEditCluesetSkipClueShort.string,
        ]
    }

    func refreshNextButtonState() {
        let titles = nextTitles()
        nextClueButton.setTitle(titles.long.string, for: .normal)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: titles.short.string, style: .plain, target: self, action: #selector(EditCluesViewController.nextButtonTapped))
        navigationItem.rightBarButtonItem?.accessibilityLabel = titles.long.string
        navigationItem.rightBarButtonItem?.possibleTitles = allPossibleShortButtonTitles()
    }

}
