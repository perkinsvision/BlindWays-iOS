//
//  CardViewController.swift
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

class CardViewController: UIViewController {

    // MARK: View

    override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: 310, height: 440))
        view.backgroundColor = .white
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
    }

}

class CardViewControllerHelper: NSObject, UIViewControllerTransitioningDelegate {
    static let shared = CardViewControllerHelper()
    var presentationController: UIPresentationController?

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return presentationController
    }
}

extension UIViewController {
    func rz_presentCardViewController(_ cardViewController: CardViewController) {
        let effect = UIBlurEffect(style: .dark)
        CardViewControllerHelper.shared.presentationController = EffectPresentationController(effect: effect, presentedViewController: cardViewController, presentingViewController: self)
        cardViewController.transitioningDelegate = CardViewControllerHelper.shared
        cardViewController.modalPresentationStyle = .custom

        present(cardViewController, animated: true, completion: nil)
    }

}
