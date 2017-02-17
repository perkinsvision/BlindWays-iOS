//
//  ClueTypeCell.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 5/2/16.
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

final class ClueTypeCell: UITableViewCell {

    var clueType: ClueType? {
        didSet {
            if let clueType = clueType {
                typeLabel.text = clueType.title
                detailLabel.text = nil // set by row selection
                accessoryType = clueType.subTypes != nil || clueType.isOtherType ? .disclosureIndicator : .none
            }
        }
    }

    var typeLabel: UILabel!
    var detailLabel: UILabel!
    var checkmarkImageView: UIImageView!

    fileprivate var disableCancelToken: cancel_token_t?

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
        separatorInset = UIEdgeInsets(top: 0, left: typeLabel.frame.origin.x, bottom: 0, right: 0)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        if disableCancelToken != nil {
            disableCancelToken?.pointee = true
        }
        self.typeLabel.accessibilityLabel = nil
    }

    func configureView() {
        typeLabel = UILabel("typeLabel")
        contentView.addSubview(typeLabel)

        detailLabel = UILabel("detailLabel")
        contentView.addSubview(detailLabel)

        checkmarkImageView = UIImageView("checkmarkImageView")
        contentView.addSubview(checkmarkImageView)
    }

    func configureStyle() {
        backgroundColor = Colors.Common.white
        selectionStyle = .none

        typeLabel.font = UIFont.dynamicSize(style: .headline, weight: .regular)
        typeLabel.textColor = Colors.Common.black

        detailLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        detailLabel.textColor = Colors.Common.gray
        detailLabel.textAlignment = .right

        checkmarkImageView.image = Asset.icnCheckedListitem.image
        checkmarkImageView.contentMode = .center
    }

    func configureLayout() {
        typeLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        typeLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)

        checkmarkImageView.widthAnchor == 56
        checkmarkImageView.heightAnchor >= 44
        checkmarkImageView.leadingAnchor == contentView.leadingAnchor
        checkmarkImageView.topAnchor == contentView.topAnchor
        checkmarkImageView.bottomAnchor == contentView.bottomAnchor ~ UILayoutPriorityDefaultHigh

        typeLabel.leadingAnchor == checkmarkImageView.trailingAnchor
        typeLabel.topAnchor == contentView.topAnchor
        typeLabel.bottomAnchor == contentView.bottomAnchor
        typeLabel.trailingAnchor == detailLabel.leadingAnchor - 5

        detailLabel.topAnchor == contentView.topAnchor
        detailLabel.bottomAnchor == contentView.bottomAnchor
        detailLabel.trailingAnchor == contentView.trailingAnchor - 5
    }

    // MARK: Selection

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkmarkImageView.isHidden = !selected
        if !selected {
            detailLabel.text = nil
        }
    }

    // MARK: Accessibility

    func temporarilyDisableAccessibility(delay: TimeInterval) {
        typeLabel.accessibilityLabel = ""

        disableCancelToken = Utility.performAfter(delay) {
            self.typeLabel.accessibilityLabel = nil
        }
    }

}
