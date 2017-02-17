//
//  EditCluesTableHeaderView.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 4/26/16.
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

class EditCluesTableHeaderView: UIView {

    var viewModel: EditClueSetViewModel? {
        didSet {
            if let viewModel = viewModel {
                for (index, clueViewModel) in viewModel.clueViewModels.enumerated() {
                    let filled = clueViewModel.type != nil
                    clueSlotControl.setSlotFilled(at: index, filled: filled)
                }
            }
        }
    }

    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.imgAddclueStreetbackground.image)
        imageView.accessibilityIdentifier = "backgroundImageView"
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let busImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.imgAddclueBusbody.image)
        imageView.accessibilityIdentifier = "busImageView"
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()

    let busWheelImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.imgAddclueBuswheels.image)
        imageView.accessibilityIdentifier = "busWheelImageView"
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()

    let busStopSignImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.imgAddclueSign.image)
        imageView.accessibilityIdentifier = "busStopSignImageView"
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()

    let clueSlotControl = ClueSlotSelectionControl()

    var hasTriggeredIntroAnimation: Bool = false

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.Common.lightGray
        configureView()
        configureLayout()
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    override func layoutSubviews() {
        if !hasTriggeredIntroAnimation {
            busImageView.layoutIfNeeded()
            busWheelImageView.layoutIfNeeded()
            busImageView.layer.transform = CATransform3DMakeTranslation(-(busImageView.frame.maxX), 0, 0)
            busWheelImageView.layer.transform = CATransform3DMakeTranslation(-(busWheelImageView.frame.maxX), 0, 0)
        }
    }

    func configureView() {
        addSubview(backgroundImageView)
        addSubview(busWheelImageView)
        addSubview(busImageView)
        addSubview(clueSlotControl)
        addSubview(busStopSignImageView)
    }

    func configureLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let scaleFactor = UIScreen.main.bounds.size.width / backgroundImageView.image!.size.width

        backgroundImageView.leadingAnchor == leadingAnchor
        backgroundImageView.trailingAnchor == trailingAnchor
        backgroundImageView.topAnchor == topAnchor
        backgroundImageView.bottomAnchor == clueSlotControl.topAnchor
        applyAspectConstraint(to: backgroundImageView)

        clueSlotControl.heightAnchor == 44
        clueSlotControl.leadingAnchor == leadingAnchor
        clueSlotControl.trailingAnchor == trailingAnchor
        clueSlotControl.bottomAnchor == bottomAnchor

        busStopSignImageView.widthAnchor == (busStopSignImageView.image!.size.width * scaleFactor)
        busStopSignImageView.centerXAnchor == centerXAnchor
        busStopSignImageView.bottomAnchor == bottomAnchor - 36
        applyAspectConstraint(to: busStopSignImageView)

        busImageView.trailingAnchor == busStopSignImageView.leadingAnchor + 7
        busImageView.widthAnchor == (busImageView.image!.size.width * scaleFactor)
        busImageView.bottomAnchor == clueSlotControl.topAnchor
        applyAspectConstraint(to: busImageView)

        busWheelImageView.trailingAnchor == busImageView.trailingAnchor
        busWheelImageView.widthAnchor == (busWheelImageView.image!.size.width * scaleFactor)
        busWheelImageView.bottomAnchor == busImageView.bottomAnchor
        applyAspectConstraint(to: busWheelImageView)
    }

    func applyAspectConstraint(to imageView: UIImageView) {
        if let size = imageView.image?.size {
            imageView.heightAnchor == imageView.widthAnchor * (size.height / size.width)
        }
    }

    // MARK: Intro

    func triggerIntroIfNeeded() {
        if !hasTriggeredIntroAnimation {
            hasTriggeredIntroAnimation = true

            let animationOptions: UIViewAnimationOptions = .curveEaseOut
            let keyframeAnimationOptions: UIViewKeyframeAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: animationOptions.rawValue)

            UIView.animateKeyframes(withDuration: 2, delay: 0.0, options: [keyframeAnimationOptions], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.9, animations: {
                    self.busImageView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 10, 0, 0)
                    self.busWheelImageView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 10, 0, 0)
                })

                UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.1, animations: {
                    self.busImageView.layer.transform = CATransform3DTranslate(self.busImageView.layer.transform, -5, 6, 0)
                    self.busWheelImageView.layer.transform = CATransform3DTranslate(self.busWheelImageView.layer.transform, -5, 0, 0)
                })

                UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1, animations: {
                    self.busImageView.layer.transform = CATransform3DIdentity
                    self.busWheelImageView.layer.transform = CATransform3DIdentity
                })

                }, completion: nil)
        }
    }

    func setSignVisible(_ visible: Bool) {
        guard (visible && busStopSignImageView.alpha != 1.0) || (!visible && busStopSignImageView.alpha != 0.0) else {
            return
        }

        UIView.animate(withDuration: 0.2, animations: {
            self.busStopSignImageView.alpha = visible ? 1.0 : 0.0
        })
    }

}
