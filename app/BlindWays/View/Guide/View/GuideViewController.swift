//
//  GuideViewController.swift
//  BlindWays
//
//  Created by Zev Eisenberg on 8/29/16.
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

final class GuideViewController: UIViewController {

    // Private Properties

    let viewModel = GuideViewModel()

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.alwaysBounceVertical = true
        tableView.indicatorStyle = .white

        tableView.register(GuideMessageCell.self, forCellReuseIdentifier: GuideMessageCell.rz_reuseID)
        tableView.register(GuideExampleCell.self, forCellReuseIdentifier: GuideExampleCell.rz_reuseID)
        tableView.register(GuideSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: GuideSectionHeaderView.rz_reuseID)
        tableView.register(GuideSectionAccessibilityOnlyHeaderView.self, forHeaderFooterViewReuseIdentifier: GuideSectionAccessibilityOnlyHeaderView.rz_reuseID)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 87.0
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 38.0
        return tableView
    }()

    let tableHeaderView: UIImageView = {
        let imageView = UIImageView(image: Asset.imgGuideHeader.image)
        imageView.accessibilityIdentifier = "tableHeaderView"
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var overScrollBackgroundHeightConstraint: NSLayoutConstraint!
    let overScrollBackground: UIView = {
        let view = UIView("overScrollBackgroundView")
        view.backgroundColor = Colors.Common.marineBlue
        return view
    }()

    fileprivate let hairline = HairlineView(axis: .horizontal, color: Colors.Common.navy)

    override func loadView() {
        view = UIView("GuideViewController.view")
        view.backgroundColor = Colors.Common.lightNavy

        view.addSubview(overScrollBackground)
        view.addSubview(tableView)
        view.addSubview(hairline)

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: UIStrings.commonClose.string, style: .plain, target: self, action: #selector(GuideViewController.closeButtonTapped(_:)))

        title = UIStrings.guideTitle.string

        tableView.edgeAnchors == edgeAnchors

        overScrollBackground.horizontalAnchors == view.horizontalAnchors
        overScrollBackground.topAnchor == tableView.topAnchor
        overScrollBackgroundHeightConstraint = (overScrollBackground.heightAnchor == 0)

        hairline.topAnchor == topLayoutGuide.bottomAnchor
        hairline.horizontalAnchors == horizontalAnchors

        tableView.reloadData()

        hairline.alpha = 0.0
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let aspectRatio = tableHeaderView.image!.size.height / tableHeaderView.image!.size.width

        let width = tableView.frame.width
        let height = width * aspectRatio
        tableHeaderView.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        tableView.tableHeaderView = tableHeaderView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Accessibility.shared.screenChanged()
    }

}

extension GuideViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel[indexPath]
        switch item {
        case .guide(let message):
            let cell = Utility.forceCast(tableView.dequeueReusableCell(withIdentifier: GuideMessageCell.rz_reuseID, for: indexPath), asType: GuideMessageCell.self)
            cell.message = message
            cell.hairlineVisible = !indexPath.isLastInSection(ofSize: self.tableView(tableView, numberOfRowsInSection: indexPath.section))
            return cell
        case .example(let message, let accessibilityPrefix, let color, let icon):
            let cell = Utility.forceCast(tableView.dequeueReusableCell(withIdentifier: GuideExampleCell.rz_reuseID, for: indexPath), asType: GuideExampleCell.self)
            cell.configuration = (message: message, accessibilityPrefix: accessibilityPrefix, color: color, icon: icon)
            return cell
        }
    }

}

extension GuideViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let header = Utility.forceCast(tableView.dequeueReusableHeaderFooterView(withIdentifier: GuideSectionAccessibilityOnlyHeaderView.rz_reuseID)!, asType: GuideSectionAccessibilityOnlyHeaderView.self)
            header.title = viewModel.sections[section].title
            return header

        case 1:
            let header = Utility.forceCast(tableView.dequeueReusableHeaderFooterView(withIdentifier: GuideSectionHeaderView.rz_reuseID)!, asType: GuideSectionHeaderView.self)
            header.title = viewModel.sections[section].title
            return header
        default:
            preconditionFailure("Request for header for unexpected section: \(section)")
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.0
        case 1:
            return 8.0
        default:
            preconditionFailure("Request for footer height for unexpected section: \(section)")
        }
    }

}

extension GuideViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            overScrollBackgroundHeightConstraint.constant = abs(scrollView.contentOffset.y)
        } else {
            overScrollBackgroundHeightConstraint.constant = 0
        }

        let offsetY = scrollView.contentOffset.y
        let hairlineAlpha = offsetY.scaled(from: 0.0...15.0, to: 0.0...1.0)
        hairline.alpha = hairlineAlpha
    }

}

private extension GuideViewController {

    @objc func closeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}

private extension IndexPath {

    func isLastInSection(ofSize sectionSize: Int) -> Bool {
        return item == sectionSize - 1
    }

}
