//
//  EffectPresentationController.swift
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

import Foundation

class EffectPresentationController: UIPresentationController {

    let effectView: UIVisualEffectView
    let effect: UIVisualEffect

    init(effect: UIVisualEffect, dismissOnTap: Bool = true, presentedViewController: UIViewController, presentingViewController: UIViewController) {
        effectView = UIVisualEffectView()
        self.effect = effect
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        if dismissOnTap {
            let tap = UITapGestureRecognizer(target: self, action: #selector(EffectPresentationController.handleTap))
            effectView.addGestureRecognizer(tap)
        }
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = self.containerView, let presentedView = self.presentedView else {
            return CGRect.zero
        }

        let x = (containerView.bounds.size.width / 2) - (presentedView.bounds.size.width / 2)
        let y = (containerView.bounds.size.height / 2) - (presentedView.bounds.size.height / 2)
        let rect = CGRect(x: x, y: y, width: presentedView.bounds.size.width, height: presentedView.bounds.size.height)
        return rect
    }

    override var shouldPresentInFullscreen: Bool {
        return true
    }

    override var presentationStyle: UIModalPresentationStyle {
        return .overFullScreen
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = self.containerView else {
            return
        }

        // Hide all accessibility elements of the presenting VC to make sure they can't accidentally
        // be activated while presenting.
        presentingViewController.view.accessibilityElementsHidden = true

        effectView.frame = containerView.bounds
        containerView.insertSubview(effectView, at: 0)

        if let coordinator = self.presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context) in
                self.effectView.effect = self.effect
                }, completion: { (context) in

            })
        } else {
            self.effectView.effect = self.effect
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        // Re-enable the presenting VC's accessibility elements
        presentingViewController.view.accessibilityElementsHidden = false

        if let coordinator = self.presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context) in
                self.effectView.effect = nil
                }, completion: { (context) in
                self.effectView.removeFromSuperview()
            })
        } else {
            self.effectView.effect = nil
            self.effectView.removeFromSuperview()
        }
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        guard let containerView = self.containerView, let presentedView = self.presentedView else {
            return
        }

        effectView.frame = containerView.bounds
        presentedView.frame = self.frameOfPresentedViewInContainerView
    }

    func handleTap() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }

}
