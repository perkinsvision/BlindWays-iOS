//
//  EditClueBoolCell.swift
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

@objc
protocol EditClueBoolCellActions {

    func switchChanged(_ sender: EditClueBoolCell)

}

final class EditClueBoolCell: UITableViewCell {

    var field: EditClueField<Bool>? {
        didSet {
            if let field = field {
                fieldTitleLabel.text = field.title
                fieldTitleLabel.numberOfLines = 0

                if let fieldSwitch = accessoryView as? UISwitch {
                    fieldSwitch.isOn = field.value ?? false
                }
            }
        }
    }

    var fieldTitleLabel: PaddedLabel!

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

    // MARK: View

    override func layoutSubviews() {
        super.layoutSubviews()
        separatorInset = UIEdgeInsets(top: 0, left: fieldTitleLabel.frame.origin.x, bottom: 0, right: 0)
    }

    func configureView() {
        selectionStyle = .none
        fieldTitleLabel = PaddedLabel(withPadding: UIEdgeInsets(top: 10.0,
            left: 0.0,
            bottom: 10.0,
            right: 0.0))
        contentView.addSubview(fieldTitleLabel)

        let fieldSwitch = UISwitch()
        fieldSwitch.addTarget(self, action: #selector(EditClueBoolCell.switchAction(_:)), for: .valueChanged)
        accessoryView = fieldSwitch
    }

    func configureStyle() {
        fieldTitleLabel.font = UIFont.dynamicSize(style: .headline, weight: .regular)
        fieldTitleLabel.textColor = Colors.Common.black

        if let valueSwitch = accessoryView as? UISwitch {
            valueSwitch.onTintColor = Colors.Common.darkGrassGreen
        }
    }

    func configureLayout() {
        fieldTitleLabel.leadingAnchor == contentView.leadingAnchor + 20
        fieldTitleLabel.trailingAnchor == contentView.trailingAnchor - 10
        fieldTitleLabel.topAnchor == contentView.topAnchor
        fieldTitleLabel.bottomAnchor == contentView.bottomAnchor ~ UILayoutPriorityDefaultHigh
        fieldTitleLabel.heightAnchor >= 44
    }

    func switchAction(_ sender: UISwitch) {
        if let field = field {
            field.value = sender.isOn
        }
        UIApplication.shared.sendAction(#selector(EditClueBoolCellActions.switchChanged(_:)), to: nil, from: self, for: nil)
    }

}
