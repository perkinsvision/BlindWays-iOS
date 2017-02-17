//
//  LocationBeakView.swift
//  BlindWays
//
//  Created by Zev Eisenberg on 10/6/16.
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

final class LocationBeakView: UIView {

    init() {
        super.init(frame: .zero)
        isOpaque = false
        clipsToBounds = true
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let beak = CGMutablePath()
        let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        let top: CGFloat = 7
        beak.move(to: CGPoint(x: center.x, y: top))
        beak.addArc(center: center, radius: 9.0, startAngle: -2.1, endAngle: -1.0, clockwise: false)
        beak.closeSubpath()

        Colors.Common.mapAnnotation.setFill()
        UIBezierPath(cgPath: beak).fill()
    }

}
