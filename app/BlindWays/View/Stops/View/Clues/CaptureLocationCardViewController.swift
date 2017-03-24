//
//  CaptureLocationCardViewController.swift
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

import MapKit
import Anchorage
import BonMot

class CaptureLocationCardViewController: InfoCardViewController, UIViewControllerTransitioningDelegate {

    fileprivate let editClueViewModel: EditClueSetViewModel
    fileprivate let editingDismissalHandler: ((_ dismissalCompletion: Block?) -> Void)

    fileprivate var location: CLLocation?
    fileprivate var hasDelayExpired: Bool = false

    fileprivate let cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle(UIStrings.commonCancel.string, for: .normal)
        cancelButton.tintColor = Colors.Common.darkGrassGreen
        return cancelButton
    }()

    fileprivate let spinnerImageView: UIImageView = {
        let imageView = UIImageView("spinnerImageView")
        imageView.image = UIImage.animatedImageNamed("geo-spinner", duration: 1)
        imageView.backgroundColor = .clear
        imageView.contentMode = .center
        return imageView
    }()

    fileprivate let loadingTitleLabel: UILabel = {
        let label = UILabel("loadingTitleLabel")
        label.text = UIStrings.stopDetailEditCluesetCaptureLocationCardLoadingTitle.string
        label.accessibilityLabel = UIStrings.stopDetailEditCluesetAccessibilityLocatingTitle.string
        return label
    }()

    fileprivate let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.isUserInteractionEnabled = false
        return mapView
    }()

    fileprivate let zoomTransition = ZoomRectTransition()

    init(viewModel: EditClueSetViewModel, editingDismissalHandler: @escaping ((_ dismissalCompletion: Block?) -> Void)) {
        self.editClueViewModel = viewModel
        self.editingDismissalHandler = editingDismissalHandler

        let headlinePointSize = UIFont.preferredFont(forTextStyle: .headline).pointSize
        let baseFont = UIFont.systemFont(ofSize: headlinePointSize, weight: UIFontWeightRegular)
        let heavyFont = UIFont.systemFont(ofSize: headlinePointSize, weight: UIFontWeightHeavy)

        let fullStyle = StringStyle(
            .alignment(.center),
            .color(Colors.Common.black),
            .font(baseFont),
            .xmlRules([
                .style("bold", StringStyle(
                    .font(heavyFont)
                    )),
                ])
        )

        let message = UIStrings.stopDetailEditCluesetCaptureLocationCardThanksMessage.string.styled(with: fullStyle)

        let infoCardViewModel = InfoCardViewModel(
            tintColor: Colors.Common.darkGrassGreen,
            messages: [message],
            image: Asset.imgGeomap.image,
            backgroundColor: Colors.Common.white,
            actionTitle: UIStrings.commonContinue.string,
            actionSelector: nil
        )
        super.init(viewModel: infoCardViewModel)
    }

    // MARK: View

    override func loadView() {
        super.loadView()

        imageView.insertSubview(mapView, belowSubview: gradientView)
        view.addSubview(cancelButton)
        view.addSubview(spinnerImageView)
        view.addSubview(loadingTitleLabel)
    }

    override func configureView() {
        super.configureView()

        imageView.backgroundColor = .clear

        cancelButton.titleLabel?.font = actionButton.titleLabel?.font
        cancelButton.addTarget(self, action: #selector(CaptureLocationCardViewController.cancelTapped), for: .touchUpInside)

        loadingTitleLabel.font = UIFont.systemFont(ofSize: 28.0, weight: UIFontWeightSemibold)
        loadingTitleLabel.textColor = Colors.Common.black
        loadingTitleLabel.textAlignment = .center
    }

    override func configureLayout() {
        super.configureLayout()

        cancelButton.edgeAnchors == actionButton.edgeAnchors

        spinnerImageView.widthAnchor == 188
        spinnerImageView.heightAnchor == 188
        spinnerImageView.centerXAnchor == imageView.centerXAnchor
        spinnerImageView.centerYAnchor == imageView.centerYAnchor

        spinnerImageView.bottomAnchor <= loadingTitleLabel.topAnchor - 10.0

        mapView.edgeAnchors == imageView.edgeAnchors

        loadingTitleLabel.leadingAnchor == view.leadingAnchor
        loadingTitleLabel.trailingAnchor == view.trailingAnchor
        loadingTitleLabel.bottomAnchor == cancelButton.topAnchor - 16.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setIsLoading(true)

        Utility.performAfter(1.5) {
            self.hasDelayExpired = true
            if self.location != nil {
                self.doneFetching()
            }
        }

        editClueViewModel.updateStopLocation { (result) in
            self.location = result.value
            if self.hasDelayExpired {
                self.doneFetching()
            }
        }
    }

    func doneFetching() {
        self.animateAllViewsVisible(false, block: {
            self.setIsLoading(false)
            self.focusMap()
            self.animateAllViewsVisible(true, block: {
                Accessibility.shared.layoutChanged(focusView: self.labelsStackView.subviews.first)
            })
        })
    }

    func setIsLoading(_ loading: Bool) {
        mapView.isHidden = loading
        labelsStackView.isHidden = loading
        actionButton.isHidden = loading
        actionButton.isEnabled = !loading
        updateActionButtonAppearance(lightBackground: loading)

        spinnerImageView.isHidden = !loading
        loadingTitleLabel.isHidden = !loading
        cancelButton.isHidden = !loading
        cancelButton.isEnabled = loading

        if loading {
            spinnerImageView.startAnimating()
        } else {
            spinnerImageView.stopAnimating()
        }
    }

    func animateAllViewsVisible(_ visible: Bool, block: Block? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            for view in self.view.subviews {
                view.alpha = visible ? 1.0 : 0.0
            }
            }, completion: { _ in
                block?()
        })
    }

    // MARK: Actions

    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    override func handleButtonAction() {
        let editCluesVC = EditCluesViewController(viewModel: editClueViewModel, editingDismissalHandler: editingDismissalHandler)
        let nav = UINavigationController(rootViewController: editCluesVC)
        nav.transitioningDelegate = self
        present(nav, animated: true, completion: nil)
    }

    // MARK: Map

    func focusMap() {
        if let location = self.location, location.hasValidCoordinate {
            self.mapView.rz_showLocation(location, animated: false, spanDelta: 0.002)
        } else {
            mapView.isHidden = true
            imageView.isHidden = false
        }
    }

    // MARK: Transition

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return zoomTransition
    }

}
