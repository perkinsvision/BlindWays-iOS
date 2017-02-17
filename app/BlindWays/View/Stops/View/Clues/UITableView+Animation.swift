//
//  UITableView+Animation.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 7/8/16.
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

import UIKit

extension UITableView {

    fileprivate struct Constants {

        static let animationDuration: TimeInterval = 0.3
        static let fadeMaskAlpha: CGFloat = 0.4

    }

    enum ReloadAnimationDirection {

        case left
        case right

    }

    /**
     Animate changes in a table view via a slide out/in animation. Provide a block with changes you'd
     like to perform and an optional block to be invoked on animation completion.
     */
    func rz_performChangesUsingSlideAnimation(direction: ReloadAnimationDirection, changes: Block, completion: Block? = nil) {
        isUserInteractionEnabled = false

        let preRect = rz_allSectionsRect()
        let preSnapshot = self.resizableSnapshotView(from: preRect, afterScreenUpdates: false, withCapInsets: UIEdgeInsets())
        preSnapshot?.frame.origin = preRect.origin

        let overlay = UIView(frame: (preSnapshot?.bounds)!)
        overlay.backgroundColor = .black
        overlay.alpha = 0.0
        preSnapshot?.addSubview(overlay)

        changes()

        let postRect = self.rz_allSectionsRect()
        let postSnapshot = self.resizableSnapshotView(from: postRect, afterScreenUpdates: true, withCapInsets: UIEdgeInsets())
        postSnapshot?.frame.origin = postRect.origin

        addSubview(preSnapshot!)
        addSubview(postSnapshot!)

        let translate = direction == .right ? -bounds.width : bounds.width
        postSnapshot?.transform = CGAffineTransform(translationX: translate, y: 0.0)

        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: [], animations: {
            overlay.alpha = Constants.fadeMaskAlpha
            preSnapshot?.transform = CGAffineTransform(translationX: translate * -1, y: 0.0)
            postSnapshot?.transform = CGAffineTransform.identity
            }) { _ in
                preSnapshot?.removeFromSuperview()
                postSnapshot?.removeFromSuperview()
                self.isUserInteractionEnabled = true
                completion?()
        }
    }

    fileprivate func rz_allSectionsRect() -> CGRect {
        let headerHeight = tableHeaderView?.bounds.height ?? 0.0
        return CGRect(x: 0, y: headerHeight, width: contentSize.width, height: contentSize.height - headerHeight)
    }

}
