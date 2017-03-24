//
//  GroupdSectionHeaderView.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 5/3/16.
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

class GroupdSectionHeaderView: UITableViewHeaderFooterView {

    static let reuseID = "GroupdSectionHeaderView"

    var title: String? {
        didSet {
            if let title = title {
                sectionTitleLabel.text = title
            }
        }
    }

    var sectionTitleLabel: UILabel!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureView()
        configureStyle()
        configureLayout()
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    func configureView() {
        sectionTitleLabel = UILabel()
        contentView.addSubview(sectionTitleLabel)
    }

    func configureStyle() {
        contentView.backgroundColor = Colors.Common.lightGray

        sectionTitleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        sectionTitleLabel.textColor = Colors.System.tableViewGroupedTitleColor
    }

    func configureLayout() {
        sectionTitleLabel.leadingAnchor == contentView.leadingAnchor + 20
        sectionTitleLabel.topAnchor == contentView.topAnchor + 27
        sectionTitleLabel.bottomAnchor == contentView.bottomAnchor - 10
        sectionTitleLabel.trailingAnchor == contentView.trailingAnchor - 5
    }

}
