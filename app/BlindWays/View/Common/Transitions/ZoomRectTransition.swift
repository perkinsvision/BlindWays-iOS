//
//  ZoomRectTransition.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 5/10/16.
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

class ZoomRectTransition: NSObject, UIViewControllerAnimatedTransitioning {

    static let transitionDuration: TimeInterval = 1

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return ZoomRectTransition.transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.fromView, let toView = transitionContext.toView else {
            return
        }

        let containerView = transitionContext.containerView

        containerView.addSubview(fromView)

        let rectSnapshot = fromView.snapshotView(afterScreenUpdates: true)
        if let rectSnapshot = rectSnapshot {
            containerView.addSubview(rectSnapshot)
        }
        rectSnapshot?.center = CGPoint(x: containerView.bounds.size.width / 2, y: containerView.bounds.size.height / 2)
        fromView.alpha = 0.0

        let toSnapshot = toView.resizableSnapshotView(from: toView.bounds, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.init())
        toSnapshot?.frame = containerView.bounds
        toSnapshot?.alpha = 0.0

        if let toSnapshot = toSnapshot {
            containerView.addSubview(toSnapshot)
        }

        UIView.animate(withDuration: ZoomRectTransition.transitionDuration, delay: 0, options: .curveEaseOut, animations: {
            let transform = CATransform3DMakeScale(2.0, 2.0, 1.0)
            rectSnapshot?.layer.transform = transform

            rectSnapshot?.alpha = 0.0
            toSnapshot?.alpha = 1.0
        }, completion: { (success) in
            containerView.addSubview(toView)
            fromView.removeFromSuperview()
            rectSnapshot?.removeFromSuperview()
            toSnapshot?.removeFromSuperview()
            transitionContext.completeTransition(success)
        })
    }

}

extension UIViewControllerContextTransitioning {

    var toView: UIView? {
        return self.view(forKey: UITransitionContextViewKey.to)
    }

    var fromView: UIView? {
        return self.view(forKey: UITransitionContextViewKey.from)
    }

}
