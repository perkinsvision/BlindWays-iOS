//
//  EditCluesSectionHeaderView.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 4/27/16.
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
import BonMot

class EditCluesSectionHeaderView: UITableViewHeaderFooterView {

    static let reuseID = "EditCluesSectionHeaderView"

    var viewModel: EditClueViewModel? {
        didSet {
            if let viewModel = viewModel {
                titleLabel.text = viewModel.sectionTitle

                let baseFont = UIFont.dynamicSize(style: .title2, weight: .regular)
                let semiboldFont = UIFont.dynamicSize(style: .title2, weight: .semibold)
                let heavyFont = UIFont.dynamicSize(style: .title2, weight: .heavy)

                let baseStyle = StringStyle(.color(Colors.Common.white))

                let fullStyle = StringStyle(
                    .color(Colors.Common.white),
                    .font(baseFont),
                    .xmlRules([
                        .style("bold", baseStyle.byAdding(.font(heavyFont))),
                        .style("semibold", baseStyle.byAdding(.font(semiboldFont))),
                        ])
                )

                detailLabel.attributedText = viewModel.sectionDetail.styled(with: fullStyle)
            }
        }
    }

    var titleLabel: UILabel!
    var detailLabel: UILabel!

    // MARK: Init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureView()
        configureStyle()
        configureLayout()

        titleLabel.text = "Please face Mt. Auburn St."
        detailLabel.text = "What is the first landmark to the left of the bus stop sign?"
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    func configureView() {
        titleLabel = UILabel("titleLabel")
        contentView.addSubview(titleLabel)

        detailLabel = UILabel("detailLabel")
        contentView.addSubview(detailLabel)
    }

    func configureStyle() {
        contentView.backgroundColor = Colors.Common.darkGrassGreen

        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.textColor = Colors.Common.white
        titleLabel.numberOfLines = 0

        detailLabel.font = UIFont.dynamicSize(style: .title2, weight: .semibold)
        detailLabel.textColor = Colors.Common.white
        detailLabel.numberOfLines = 0
    }

    func configureLayout() {
        let defaultHorizontalPadding: CGFloat = 20.0
        let defaultVerticalPadding: CGFloat = 16.0

        titleLabel.topAnchor == contentView.topAnchor + 12
        titleLabel.leadingAnchor == contentView.leadingAnchor + defaultHorizontalPadding
        // Separated to keep compile time down
        let titleTrailingLayout = contentView.trailingAnchor - 12
        titleLabel.trailingAnchor == titleTrailingLayout ~ UILayoutPriorityDefaultHigh

        detailLabel.topAnchor == titleLabel.bottomAnchor + 10
        detailLabel.leadingAnchor == contentView.leadingAnchor + defaultHorizontalPadding
        let detailTrailingLayout = contentView.trailingAnchor - defaultHorizontalPadding
        detailLabel.trailingAnchor == detailTrailingLayout ~ UILayoutPriorityDefaultHigh
        let detailBottomLayout = contentView.bottomAnchor - defaultVerticalPadding
        detailLabel.bottomAnchor == detailBottomLayout ~ UILayoutPriorityDefaultHigh
    }

    override var accessibilityLabel: String? {
        set {
            super.accessibilityLabel = newValue
        }
        get {
            return "\(titleLabel.text ?? ""), \(detailLabel.text ?? "")"
        }
    }

}
