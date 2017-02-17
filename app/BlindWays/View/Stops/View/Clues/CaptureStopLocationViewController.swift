//
//  CaptureStopLocationViewController.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 5/9/16.
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

import CoreLocation
import Anchorage

class CaptureStopLocationViewController: UIViewController {

    fileprivate let viewModel: EditClueSetViewModel
    fileprivate let editingDismissalHandler: ((_ dismissalCompletion: Block?) -> Void)

    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView("imageView")
        imageView.image = Asset.photoGeo.image
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    fileprivate let infoLabel: UILabel = {
        let infoLabel = UILabel("infoLabel")
        infoLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        infoLabel.textColor = Colors.Common.white
        infoLabel.numberOfLines = 10
        infoLabel.textAlignment = .center
        infoLabel.text = UIStrings.stopDetailEditCluesetCaptureLocationInfoMessage.string
        return infoLabel
    }()

    fileprivate let captureButton: UIButton = {
        let button = Appearance.modalButton(color: Colors.Common.white, textColor: Colors.Common.black)
        button.accessibilityIdentifier = "captureButton"
        button.setTitle(UIStrings.stopDetailEditCluesetCaptureLocationCaptureButtonTitle.string, for: .normal)
        return button
    }()

    fileprivate let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.accessibilityIdentifier = "skipButton"
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.tintColor = Colors.Common.white
        button.titleLabel?.textAlignment = .center
        button.setTitle(UIStrings.stopDetailEditCluesetCaptureLocationSkipButtonTitle.string, for: .normal)
        return button
    }()

    fileprivate let stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()

    // MARK: Init

    init(viewModel: EditClueSetViewModel, editingDismissalHandler: @escaping ((_ dismissalCompletion: Block?) -> Void)) {
        self.viewModel = viewModel
        self.editingDismissalHandler = editingDismissalHandler
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.rz_setTextPronounceable(viewModel.stopName)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CaptureStopLocationViewController.cancelTapped))
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = Colors.Common.darkGrassGreen

        view.addSubview(imageView)

        let spacer1 = UIView("spacer1")
        spacer1.heightAnchor == 35

        let spacer2 = UIView("spacer2")
        spacer2.heightAnchor == 30

        stackView.add(arrangedSubviews: [
            infoLabel,
            spacer1,
            captureButton,
            spacer2,
            skipButton,
            ])
        view.addSubview(stackView)
    }

    func configureView() {
        captureButton.addTarget(self, action: #selector(CaptureStopLocationViewController.okayTapped), for: .touchUpInside)

        skipButton.addTarget(self, action: #selector(CaptureStopLocationViewController.skipTapped), for: .touchUpInside)
    }

    func configureLayout() {
        imageView.edgeAnchors == view.edgeAnchors

        stackView.horizontalAnchors == view.horizontalAnchors + 44
        stackView.bottomAnchor == view.bottomAnchor - 30
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navBar = navigationController?.navigationBar {
            navBar.shadowImage = nil
            navBar.setBackgroundImage(nil, for: .default)
            navBar.isTranslucent = true
            navBar.barStyle = .black
        }

        configureView()
        configureLayout()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: Actions

    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    func okayTapped() {
        let cardVC = CaptureLocationCardViewController(viewModel: viewModel, editingDismissalHandler: editingDismissalHandler)
        self.rz_presentCardViewController(cardVC)
    }

    func skipTapped() {
        let editCluesVC = EditCluesViewController(viewModel: viewModel, editingDismissalHandler: editingDismissalHandler)
        navigationController?.pushViewController(editCluesVC, animated: true)
    }

}
