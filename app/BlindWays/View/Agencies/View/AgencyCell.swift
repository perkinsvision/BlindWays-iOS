//
//  AgencyCell.swift
//  BlindWays
//
//  Created by Fabien Legoupillot on 1/26/17.
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

final class AgencyCell: UITableViewCell {

    var viewModel: AgencyViewModel? {
        didSet {
            if let viewModel = viewModel {
                nameLabel.rz_setTextPronounceable(viewModel.localizedTitle)
                imageView?.image = viewModel.isSelected ? UIImage(asset: .icnCheckedAgencyItem) : nil
            }
        }
    }

    private let nameLabel: UILabel = {
        let label = UILabel("nameLabel")
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightHeavy)
        label.numberOfLines = 0
        return label
    }()

    // MARK: Init

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureStyle()
        configureLayout()
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        separatorInset = UIEdgeInsets(top: 0, left: nameLabel.frame.origin.x, bottom: 0, right: 0)
    }

    // MARK: View

    func configureView() {
        selectionStyle = .none
        contentView.addSubview(nameLabel)
    }

    func configureStyle() {
        backgroundColor = Colors.Common.white
        contentView.backgroundColor = Colors.Common.white
    }

    func configureLayout() {
        nameLabel.verticalAnchors == contentView.verticalAnchors + 10
        nameLabel.leadingAnchor == contentView.leadingAnchor + 60
        nameLabel.trailingAnchor == contentView.trailingAnchor - 20
        nameLabel.heightAnchor >= 56
    }

}
