//
//  ClueCell.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 4/13/16.
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
protocol ClueCellActions {

    func addEditClueTapped(_ sender: UITableViewCell)
    func moreActionsTapped(_ sender: UITableViewCell)
    func reportProblemTapped(_ sender: UITableViewCell)
    func confirmClueTapped(_ sender: UITableViewCell)
    func deleteClueTapped(_ sender: UITableViewCell)
    func clueCellBecameFocusedAccessibilityElement(_ sender: UITableViewCell)

}

final class ClueCell: UITableViewCell {

    // Public Properties

    var viewModel: ClueDisplayable? {
        didSet {
            if let viewModel = viewModel {
                indexLabel.text = "\(viewModel.clueNumber)"
                clueTextLabel.text = viewModel.localizedText
                iconImageView.isHidden = !viewModel.isBusStopSign

                let hasClue = viewModel.clue != nil
                indexLabel.textColor = viewModel.style.indexLabelColor(hasClue: hasClue)
                clueTextLabel.textColor = viewModel.style.clueTextLabelColor(hasClue: hasClue)
                iconImageView.tintColor = viewModel.style.indexLabelColor(hasClue: hasClue)

                if viewModel.isBusStopSign {
                    // ??? - Can't hide the label for bus stop cell because we want VoiceOver to still read it.
                    indexLabel.textColor = .clear
                }

                accessoryView = createAccessoryView(viewModel: viewModel)

                if let button = accessoryView as? UIButton, accessibilityCustomActions == nil {
                    let axLabelPrefix: String?

                    // If it is non-nil, use the override instead of the default accessibility label.
                    // This lets us provide accessibility-only context that would be obvious to sighted users.
                    if let viewModelLabel = viewModel.localizedAccessibilityOverride {
                        axLabelPrefix = viewModelLabel
                    } else {
                        if let clueTextAxLabel = clueTextLabel.text, !clueTextAxLabel.characters.isEmpty {
                            axLabelPrefix = clueTextAxLabel
                        } else {
                            axLabelPrefix = nil
                        }
                    }

                    // Make sure it has a period and no trailing spaces
                    let axLabelPrefixTrimmed = axLabelPrefix?.rz_trimmed.rz_sentenceTerminated.rz_trimmed

                    let axLabel: String?
                    let buttonAxLabelOrTitle = (button.accessibilityLabel ?? button.title(for: .normal))
                    if let prefix = axLabelPrefixTrimmed, let buttonLabel = buttonAxLabelOrTitle, !prefix.characters.isEmpty && !buttonLabel.characters.isEmpty {
                        axLabel = UIStrings.commonConcatenateTwoSentences(prefix, buttonLabel).string
                    } else {
                        axLabel = buttonAxLabelOrTitle
                    }

                    clueTextLabel.accessibilityLabel = axLabel
                }
            } else {
                accessoryView = nil
            }
        }
    }

    var stopDetailViewModel: StopDetailViewModel?

    let separatorView = HairlineView(axis: .horizontal)
    let firstCellSeparator = HairlineView(axis: .horizontal)
    let lastCellSeparator = HairlineView(axis: .horizontal)

    let indexLabel: UILabel = {
        let label = UILabel("indexLabel")
        label.font = UIFont.systemFont(ofSize: 28.0, weight: UIFontWeightLight)
        label.textColor = Colors.Common.black
        label.textAlignment = .center
        return label
    }()

    let clueTextLabel: UILabel = {
        let label = UILabel("clueTextLabel")
        label.font = UIFont.dynamicSize(style: .headline, weight: .regular)
        label.textColor = Colors.Common.black
        label.numberOfLines = 50
        return label
    }()

    // Private Properties

    fileprivate let iconImageView: UIImageView = {
        let imageView = UIImageView("iconImageView")
        imageView.image = Asset.icnBus.image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Colors.Common.windowsBlue
        imageView.contentMode = .center
        return imageView
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

    // MARK: View

    override func prepareForReuse() {
        super.prepareForReuse()
        separatorView.isHidden = true
        firstCellSeparator.isHidden = true
        lastCellSeparator.isHidden = true
        clueTextLabel.accessibilityLabel = nil
    }

    // MARK: Accessibility

    override var accessibilityCustomActions: [UIAccessibilityCustomAction]? {
        get {
            if let viewModel = viewModel, viewModel.clue != nil, viewModel.style == .navigation {
                var actions = [UIAccessibilityCustomAction]()
                if User.loggedInUser != nil && !viewModel.confirmed {
                    actions.append(UIAccessibilityCustomAction(name: UIStrings.stopDetailClueActionsConfirmTitle.string, target: self, selector: #selector(ClueCell.confirmTapped)))
                }
                actions.append(UIAccessibilityCustomAction(name: UIStrings.stopDetailClueActionsEditClueTitle.string, target: self, selector: #selector(ClueCell.addEditTapped)))
                actions.append(UIAccessibilityCustomAction(name: UIStrings.stopDetailClueActionsReportProblemTitle.string, target: self, selector: #selector(ClueCell.reportTapped)))

                if let stopDetailViewModel = stopDetailViewModel, stopDetailViewModel.userIsInVicinityOfStop {
                    actions.append(UIAccessibilityCustomAction(name: UIStrings.stopDetailClueActionsDeleteClueTitle.string, target: self, selector: #selector(ClueCell.deleteTapped)))
                }

                return actions
            } else {
                return nil
            }
        }
        set (actions) {
            super.accessibilityCustomActions = actions
        }
    }

    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            if viewModel?.clue != nil && viewModel?.style == .navigation {
                return super.accessibilityTraits
            } else {
                return UIAccessibilityTraitButton | super.accessibilityTraits
            }
        }
        set (traits) {
            super.accessibilityTraits = traits
        }
    }

    override func accessibilityElementDidBecomeFocused() {
        super.accessibilityElementDidBecomeFocused()
        UIApplication.shared.sendAction(#selector(ClueCellActions.clueCellBecameFocusedAccessibilityElement(_:)), to: nil, from: self, for: nil)
    }

}

private extension ClueCell {

    func configureView() {
        contentView.addSubview(indexLabel)
        contentView.addSubview(clueTextLabel)
        contentView.addSubview(iconImageView)

        addSubview(separatorView)
        addSubview(firstCellSeparator)
        addSubview(lastCellSeparator)

        separatorView.isHidden = true
        firstCellSeparator.isHidden = true
        lastCellSeparator.isHidden = true
    }

    func configureStyle() {
        selectionStyle = .none
        backgroundColor = Colors.Common.white
        contentView.backgroundColor = Colors.Common.white
    }

    func configureLayout() {
        let verticalTextPadding: CGFloat = 13.0
        let leadingTextMargin: CGFloat = 56.0

        let indexCenteringGuide = UILayoutGuide("indexCenteringGuide")

        contentView.addLayoutGuide(indexCenteringGuide)
        indexCenteringGuide.widthAnchor == leadingTextMargin

        iconImageView.centerXAnchor == indexCenteringGuide.centerXAnchor
        iconImageView.centerYAnchor == indexCenteringGuide.centerYAnchor

        indexCenteringGuide.leadingAnchor == contentView.leadingAnchor
        indexCenteringGuide.verticalAnchors == contentView.verticalAnchors

        indexLabel.centerXAnchor == iconImageView.centerXAnchor
        indexLabel.centerYAnchor == iconImageView.centerYAnchor

        clueTextLabel.verticalAnchors == contentView.verticalAnchors + verticalTextPadding
        clueTextLabel.leadingAnchor == indexCenteringGuide.trailingAnchor
        clueTextLabel.trailingAnchor == contentView.trailingAnchor - 8

        // Hairlines are not pinned to contentView horizontally so that they
        // will not be inset by accessory views.

        separatorView.leadingAnchor == clueTextLabel.leadingAnchor
        separatorView.trailingAnchor == trailingAnchor // not contentView!
        separatorView.bottomAnchor == contentView.bottomAnchor

        firstCellSeparator.horizontalAnchors == horizontalAnchors // not contentView!
        firstCellSeparator.topAnchor == contentView.topAnchor

        lastCellSeparator.horizontalAnchors == horizontalAnchors // not contentView!
        lastCellSeparator.bottomAnchor == contentView.bottomAnchor
    }

    func createMoreButton() -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = Colors.Common.windowsBlue
        button.setImage(Asset.icnOptions.image, for: .normal)
        button.sizeToFit()

        button.addTarget(self, action: #selector(ClueCell.moreTapped), for: .touchUpInside)

        button.isAccessibilityElement = false

        return button
    }

    func createAccessoryView(viewModel: ClueDisplayable) -> UIView? {
        let hasClue = (viewModel.clue != nil)
        switch (viewModel.style, hasClue) {
        case (.navigation, true): return createMoreButton()
        case (.navigation, false): return createAddEditButton(title: UIStrings.stopDetailAddClueButtonTitle.string,
                                                              tintColor: Colors.Common.windowsBlue)
        case (.review, true): return createAddEditButton(title: UIStrings.stopDetailEditClueButtonTitle.string,
                                                         tintColor: Colors.Common.darkGrassGreen)
        case (.review, false): return createIconAddButton(accessibilityLabel: UIStrings.stopDetailAddClueButtonTitle.string,
                                                          tintColor: Colors.Common.darkGrassGreen)
        }
    }

    // MARK: Actions

    @objc func addEditTapped() {
        UIApplication.shared.sendAction(#selector(ClueCellActions.addEditClueTapped(_:)), to: nil, from: self, for: nil)
    }

    @objc func reportTapped() {
        UIApplication.shared.sendAction(#selector(ClueCellActions.reportProblemTapped(_:)), to: nil, from: self, for: nil)
    }

    @objc func confirmTapped() {
        UIApplication.shared.sendAction(#selector(ClueCellActions.confirmClueTapped(_:)), to: nil, from: self, for: nil)
    }

    @objc func deleteTapped() {
        UIApplication.shared.sendAction(#selector(ClueCellActions.deleteClueTapped(_:)), to: nil, from: self, for: nil)
    }

    @objc func moreTapped() {
        UIApplication.shared.sendAction(#selector(ClueCellActions.moreActionsTapped(_:)), to: nil, from: self, for: nil)
    }

    /**
     Creates a button that functions as an add or edit button
     */
    func createAddEditButton(title: String, tintColor: UIColor) -> UIButton {
        let button = TintedButton(backgroundColor: Colors.Common.white, tintColor: tintColor)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        button.titleLabel?.textAlignment = .center
        button.setTitle(title, for: .normal)
        button.sizeToFit()
        button.isAccessibilityElement = false
        button.accessibilityElementsHidden = true

        let extraPadding: CGFloat = 12
        button.bounds = CGRect(x: 0, y: 0, width: button.bounds.width + extraPadding, height: button.bounds.size.height)

        button.addTarget(self, action: #selector(ClueCell.addEditTapped), for: .touchUpInside)

        return button
    }

    /**
     Creates a button that functions as an add button, with no text (icon-only)
     */
    func createIconAddButton(accessibilityLabel: String, tintColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(Asset.icnAdd.image, for: .normal)
        button.accessibilityLabel = accessibilityLabel
        button.sizeToFit()
        button.isAccessibilityElement = false
        button.accessibilityElementsHidden = true
        button.tintColor = tintColor

        button.addTarget(self, action: #selector(ClueCell.addEditTapped), for: .touchUpInside)

        return button
    }

}

private extension ClueDisplayableStyle {

    func indexLabelColor(hasClue: Bool) -> UIColor {
        switch self {
        case .navigation: return hasClue ? Colors.Common.marineBlue : Colors.Common.windowsBlue
        case .review: return hasClue ? Colors.Common.marineBlue : Colors.Common.gray
        }
    }

    func clueTextLabelColor(hasClue: Bool) -> UIColor {
        switch self {
        case .navigation: return hasClue ? Colors.Common.black : Colors.Common.windowsBlue
        case .review: return hasClue ? Colors.Common.black : Colors.Common.gray
        }
    }

}

private extension ClueDisplayable {

    var clueNumber: Int {
        return index + 1
    }

}
