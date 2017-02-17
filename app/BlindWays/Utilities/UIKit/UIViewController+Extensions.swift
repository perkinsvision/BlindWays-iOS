//
//  UIViewController+Extensions.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/21/16.
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

// MARK: - Containment

extension UIViewController {

    func rz_removeChildViewController(_ child: UIViewController) {
        if child.parent == self {
            child.willMove(toParentViewController: nil)

            if child.view.isDescendant(of: view) {
                child.view.removeFromSuperview()
            }

            child.removeFromParentViewController()
        }
    }

    func rz_addChildViewController(_ child: UIViewController, inView view: UIView) {
        rz_addChildViewController(child, inView: view) { childView in
            childView.edgeAnchors == view.edgeAnchors
        }
    }

    func rz_addChildViewController(_ child: UIViewController, inView view: UIView, layoutBlock: (UIView) -> Void) {
        assert(view.isDescendant(of: self.view), "View must be a descendant of the root view.")

        child.parent?.rz_removeChildViewController(child)

        addChildViewController(child)

        view.addSubview(child.view)
        layoutBlock(child.view)

        child.didMove(toParentViewController: self)
    }

}

// MARK: - Presentation

extension UIViewController {

    @nonobjc static var rz_topPresentedViewController: UIViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController

        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }

        return topVC
    }

}

// MARK: - Activity Indicator

extension UIViewController {

    typealias ActivityIndicatorDismissal = (_ completion: Block?) -> Void

    fileprivate final class OverlayView: UIView {}

    /// Returns a function that, when invoked, reverses presentation of the spinner.
    func rz_showActivityIndicator(in view: UIView? = nil, animated: Bool = true, adjustPositionForKeyboard: Bool = false) -> ActivityIndicatorDismissal {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

        Utility.performOnMainThread {
            guard let presentationView = ((view != nil) ? view : self.view) else {
                return
            }
            self.view.isUserInteractionEnabled = false

            // A semi-transparent black overlay, so the white spinner
            // is visible over any color background
            let overlay = OverlayView()
            overlay.backgroundColor = UIColor(white: 0.0, alpha: 0.35)
            overlay.alpha = 0.0
            presentationView.addSubview(overlay)

            // !!! Can't pin to leading/trailing and top/bottom, because if presentationView is
            // a scroll view, that may not work correctly, so use leading/width and top/height instead.
            overlay.leadingAnchor == presentationView.leadingAnchor
            overlay.widthAnchor == presentationView.widthAnchor

            overlay.topAnchor == presentationView.topAnchor
            overlay.heightAnchor == presentationView.heightAnchor

            spinner.present(in: presentationView, animated: true, adjustPositionForKeyboard: adjustPositionForKeyboard, animationBlock: {
                overlay.alpha = 1.0
            })
        }

        return { [weak self] (completion) in
            Utility.performOnMainThread {
                spinner.hide(animated: true, animationBlock: {
                    self?.overlayView()?.alpha = 0.0
                    }, completion: {
                        self?.view.isUserInteractionEnabled = true
                        completion?()
                        self?.overlayView()?.removeFromSuperview()
                })

            }
        }
    }

    fileprivate func overlayView() -> UIView? {
        for view in self.view.subviews {
            if let view = view as? OverlayView {
                return view
            }
        }

        return nil
    }

}
