//
//  ReviewCluesTextViewCell.swift
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
import BonMot

@objc
protocol ReviewCluesTextViewCellActions {
    func reviewCellDidBeginEditing(_ cell: ReviewCluesTextViewCell)
    func reviewCellDidEndEditing(_ cell: ReviewCluesTextViewCell)
    func reviewCellTappedHelp(_ cell: ReviewCluesTextViewCell)
}

final class ReviewCluesTextViewCell: UITableViewCell {

    struct Constants {

        static let maxChars = 140
        static let warnChars = 10

    }

    var note: EditClueField<String>? {
        didSet {
            textView.text = note?.value
            updateCharCount()
        }
    }

    let textView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.accessibilityIdentifier = "noteTextView"

        textView.font = UIFont.preferredFont(forTextStyle: .callout)
        textView.textColor = Colors.Common.black
        textView.placeholderLabel.text = UIStrings.stopDetailEditCluesetReviewNotesPlaceholder.string
        textView.placeholderLabel.font = textView.font
        textView.placeholderLabel.textColor = .lightGray
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)

        textView.tintColor = Colors.Common.darkGrassGreen
        textView.layer.masksToBounds = true
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 4.0

        return textView
    }()

    let promptLabel: UILabel = {
        let label = UILabel("promptLabel")
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = Colors.Common.black
        label.numberOfLines = 0
        label.text = UIStrings.stopDetailEditCluesetReviewNotesPrompt.string
        return label
    }()

    let helpButton: TintedButton = {
        let button = TintedButton(backgroundColor: Colors.System.tableViewGroupedBackgroundColor, tintColor: Colors.Common.darkGrassGreen)
        button.accessibilityIdentifier = "helpButton"
        button.titleLabel?.font = UIFont.dynamicSize(style: .title3, weight: .semibold)
        button.titleLabel?.textAlignment = .center
        button.setTitle("?", for: .normal)
        button.accessibilityLabel = UIStrings.stopDetailEditCluesetReviewHelpAccessibilityLabel.string
        return button
    }()

    let charLabel: UILabel = {
        let label = UILabel("charLabel")
        label.textColor = Colors.Common.darkGrassGreen
        return label
    }()

    // MARK: Init

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureLayout()
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    func configureView() {
        selectionStyle = .none

        contentView.backgroundColor = .clear
        backgroundColor = .clear

        contentView.addSubview(promptLabel)
        contentView.addSubview(helpButton)
        contentView.addSubview(textView)
        contentView.addSubview(charLabel)

        updateCharCount()
        textView.delegate = self

        helpButton.addTarget(nil, action: #selector(ReviewCluesTextViewCellActions.reviewCellTappedHelp(_:)), for: .touchUpInside)
    }

    func configureLayout() {
        let defaultPadding: CGFloat = 20.0

        // separating steps to reduce compile times
        let promptLeadingLayout = contentView.leadingAnchor + defaultPadding
        promptLabel.leadingAnchor == promptLeadingLayout
        let promptTrailingLayout = helpButton.leadingAnchor - defaultPadding
        promptLabel.trailingAnchor == promptTrailingLayout
        promptLabel.topAnchor == contentView.topAnchor
        let promptBottomLayout = textView.topAnchor - 10
        promptLabel.bottomAnchor == promptBottomLayout

        helpButton.widthAnchor == helpButton.heightAnchor
        helpButton.widthAnchor >= 30.0
        helpButton.centerYAnchor == promptLabel.centerYAnchor
        let helpTrailingLayout = contentView.trailingAnchor - 12
        helpButton.trailingAnchor == helpTrailingLayout

        let textHorizontalLayout = contentView.horizontalAnchors + 6
        textView.horizontalAnchors == textHorizontalLayout
        textView.heightAnchor == 88
        let textTopLayout = charLabel.topAnchor - 10
        textView.bottomAnchor == textTopLayout

        let charLeadingLayout = contentView.leadingAnchor + defaultPadding
        charLabel.leadingAnchor == charLeadingLayout
        let charTrailingLayout = contentView.trailingAnchor - 12
        charLabel.trailingAnchor == charTrailingLayout
        let charBottomLayout = contentView.bottomAnchor - defaultPadding
        charLabel.bottomAnchor == charBottomLayout
    }

    func updateCharCount() {
        let charsRemaning = ReviewCluesTextViewCell.Constants.maxChars - textView.text.characters.count
        let charString = charsRemaning == 1 ?
            UIStrings.stopDetailEditCluesetReviewNotesCharactersFormatSingular(charsRemaning).string :
            UIStrings.stopDetailEditCluesetReviewNotesCharactersFormatPlural(charsRemaning).string

        let font = UIFont.preferredFont(forTextStyle: .callout)
        charLabel.attributedText = charString.styled(with: .font(font), .numberSpacing(.monospaced))
        charLabel.textColor = (charsRemaning > Constants.warnChars) ? Colors.Common.darkGrassGreen : Colors.Common.darkOrange
    }

}

extension ReviewCluesTextViewCell: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        UIApplication.shared.sendAction(#selector(ReviewCluesTextViewCellActions.reviewCellDidBeginEditing(_:)), to: nil, from: self, for: nil)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        UIApplication.shared.sendAction(#selector(ReviewCluesTextViewCellActions.reviewCellDidEndEditing(_:)), to: nil, from: self, for: nil)
    }

    func textViewDidChange(_ textView: UITextView) {
        note?.value = textView.text
        if textView.text.characters.count == 0 {
            note?.value = nil
        }
        updateCharCount()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let charsRemaning = ReviewCluesTextViewCell.Constants.maxChars - (textView.text.characters.count + text.characters.count)

        if charsRemaning == Constants.warnChars && text.characters.count > 0 {
            Utility.performAfter(2, block: {
                Accessibility.shared.announce(UIStrings.stopDetailEditCluesetReviewNotesAccessibilityCharactersAnnouncement(Constants.warnChars).string)
            })
        }

        return (textView.text.characters.count + text.characters.count) <= ReviewCluesTextViewCell.Constants.maxChars
    }

}
