//
//  EditCluesReviewViewController.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 6/21/16.
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
import Swiftilities
import UIKit

class EditCluesReviewViewController: UIViewController {

    enum EditCluesReviewResult {
        case cancel
        case edit(slotIndex: Int)
    }

    typealias EditCluesReviewCompletion = ((_ result: EditCluesReviewResult) -> Void)

    fileprivate let viewModel: ReviewCluesViewModel
    fileprivate let reviewCompletion: EditCluesReviewCompletion
    fileprivate let editingDismissalHandler: ((_ dismissalCompletion: Block?) -> Void)

    fileprivate let tableView: UITableView = {
        let tableView = ControlContainableTableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()

    fileprivate var overScrollBackgroundHeightConstraint: NSLayoutConstraint!
    fileprivate let overScrollBackground: UIView = {
        let view = UIView("overScrollBackgroundView")
        view.backgroundColor = Colors.Common.darkGrassGreen
        return view
    }()

    fileprivate let hairline = HairlineView(axis: .horizontal, color: Colors.Common.deepGreen)

    // MARK: Init

    init(viewModel: ReviewCluesViewModel, reviewCompletion: @escaping EditCluesReviewCompletion, editingDismissalHandler: @escaping ((_ dismissalCompletion: Block?) -> Void)) {
        self.viewModel = viewModel
        self.reviewCompletion = reviewCompletion
        self.editingDismissalHandler = editingDismissalHandler
        super.init(nibName: nil, bundle: nil)

        self.navigationItem.title = UIStrings.stopDetailEditCluesetReviewTitle.string
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EditCluesReviewViewController.cancelTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EditCluesReviewViewController.saveTapped))
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    override func loadView() {
        view = UIView()
        view.backgroundColor = Colors.System.tableViewGroupedBackgroundColor
        view.addSubview(overScrollBackground)
        view.addSubview(tableView)
        view.addSubview(hairline)
    }

    func configureLayout() {
        overScrollBackground.horizontalAnchors == view.horizontalAnchors
        overScrollBackground.topAnchor == tableView.topAnchor
        overScrollBackgroundHeightConstraint = (overScrollBackground.heightAnchor == 0)

        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.topAnchor == view.topAnchor
        tableView.bottomAnchor == view.addKeyboardLayoutGuide().topAnchor

        hairline.topAnchor == topLayoutGuide.bottomAnchor
        hairline.horizontalAnchors == horizontalAnchors

        hairline.alpha = 0.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navBar = navigationController?.navigationBar {
            Appearance.styleNavBar(navBar, color: Colors.Common.darkGrassGreen)
        }

        configureLayout()
        configureTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if tableView.tableHeaderView == nil {
            tableView.tableHeaderView = headerView
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.endEditing(true)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // nil out the table header view to force it to be re-created on the next layout
        tableView.tableHeaderView = nil
    }

    // MARK: Action

    func cancelTapped() {
        reviewCompletion(.cancel)
        dismiss(animated: true, completion: nil)
    }

    func saveTapped() {
        tableView.endEditing(true)
        let dismissActivity = rz_showActivityIndicator(in: view, animated: true)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false

        viewModel.editClueSetViewModel.updateClueSet { (result) in
            dismissActivity(nil)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationItem.leftBarButtonItem?.isEnabled = true

            if result.isSuccess {
                self.editingDismissalHandler({
                    self.showThanksIfNeeded()
                })
            } else {
                self.rz_alert(UIStrings.commonProblem.string, message: UIStrings.stopDetailEditCluesetSaveErrorMessage.string)
            }
        }
    }

    func addEditClueTapped(_ sender: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            addEditClue(indexPath)
        }
    }

    fileprivate func addEditClue(_ indexPath: IndexPath) {
        reviewCompletion(.edit(slotIndex: indexPath.row))
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(
            name: Notification.Name(EditCluesViewController.unhighlightNextClueButtonNotificationName),
            object: nil
        )
    }

    // MARK: Thanks

    func showThanksIfNeeded() {
        if !Defaults.shared.read(UserDefaultsKeys.hasSeenClueThanks) {
            Defaults.shared.write(true, forKey: UserDefaultsKeys.hasSeenClueThanks)
            Utility.performAfter(0.5, block: {
                let cardVC = InfoCardViewController(viewModel: self.viewModel.editClueSetViewModel.thanksModalViewModel)
                // ??? Why present this on the root VC you might ask? Because at this point, we're so far down a nested
                // modal view stack that passing a completion handler through each level would be excessive.
                AppDelegate.shared.window?.rootViewController?.rz_presentCardViewController(cardVC)
            })
        }
    }

}

// MARK: Table

extension EditCluesReviewViewController: UITableViewDataSource {

    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 80

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(ClueCell.self, forCellReuseIdentifier: ClueCell.rz_reuseID)
        tableView.register(ReviewCluesTextViewCell.self, forCellReuseIdentifier: ReviewCluesTextViewCell.rz_reuseID)
    }

    var headerView: UIView {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = Colors.Common.white
        label.textAlignment = .center
        label.text = UIStrings.stopDetailEditCluesetReviewHeader.string
        label.numberOfLines = 0

        let padding: CGFloat = 20.0
        let view = UIView()
        view.backgroundColor = Colors.Common.darkGrassGreen
        view.addSubview(label)

        view.widthAnchor == tableView.bounds.width
        view.heightAnchor == 0 ~ UILayoutPriorityFittingSizeLevel
        label.horizontalAnchors == view.horizontalAnchors
        label.verticalAnchors == view.verticalAnchors + padding

        view.layoutIfNeeded()

        return view
    }

    // MARK: Data Source

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].numberOfRows
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ClueCell {
            let numRows = tableView.numberOfRows(inSection: indexPath.section)
            let isFirstRow = indexPath.row == 0
            let isLastRow = indexPath.row == numRows - 1

            cell.firstCellSeparator.isHidden = !isFirstRow
            cell.separatorView.isHidden = isLastRow
            cell.lastCellSeparator.isHidden = !isLastRow
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.sections[indexPath.section] {
        case .clues(let clues):
            let clue = clues[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: ClueCell.rz_reuseID, for: indexPath) as? ClueCell {
                cell.viewModel = clue
                return cell
            }
        case .note(let note):
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCluesTextViewCell.rz_reuseID) as? ReviewCluesTextViewCell {
                cell.note = note
                return cell
            }
        }

        return UITableViewCell()
    }

}

// Extension for optional functions from UITableViewDataSource to silence warnings
extension EditCluesReviewViewController {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let theSection = viewModel.sections[section]
        switch theSection {
        case .clues:
            return 0.0
        case .note:
            return 13.0
        }
    }

}

extension EditCluesReviewViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch viewModel.sections[indexPath.section] {
        case .clues:
            return indexPath
        case .note: return nil
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addEditClue(indexPath)
    }

    // MARK: Cell Actions

    func reviewCellDidBeginEditing(_ cell: ReviewCluesTextViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func reviewCellDidEndEditing(_ cell: ReviewCluesTextViewCell) {
        viewModel.refreshClues()
        if let indexPath = viewModel.busStopClueIndexPath() {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    func reviewCellTappedHelp(_ cell: ReviewCluesTextViewCell) {
        let guideViewController = GuideViewController()
        let navCon = UINavigationController(rootViewController: guideViewController)
        present(navCon, animated: true, completion: nil)
    }

    // MARK: Scroll View

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            overScrollBackgroundHeightConstraint.constant = abs(scrollView.contentOffset.y)
        } else {
            overScrollBackgroundHeightConstraint.constant = 0
        }

        let hairlineAlpha = offsetY.scaled(from: 16.0...22.0, to: 0.0...1.0)
        hairline.alpha = hairlineAlpha
    }

}
