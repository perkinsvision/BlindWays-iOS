//
//  GradientView.swift
//  BlindWays
//
//  Created by Zev Eisenberg on 6/8/16.
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

final class GradientView: UIView {

    enum Direction {
        case up
        case left
        case down
        case right
    }

    // Public Properties

    var direction: Direction = .down {
        didSet {
            updateGradient()
        }
    }

    var colors = (start: UIColor.white, end: UIColor.black) {
        didSet {
            updateGradient()
        }
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    var gradientLayer: CAGradientLayer {
        guard let gradientLayer = layer as? CAGradientLayer else { preconditionFailure() }
        return gradientLayer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateGradient()
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateGradient()
        backgroundColor = .clear
    }
}

private extension GradientView {

    func updateGradient() {
        let points = GradientView.gradientEndpoints(direction: direction)

        gradientLayer.startPoint = points.start
        gradientLayer.endPoint = points.end

        gradientLayer.backgroundColor = nil
        gradientLayer.colors = [colors.start.cgColor, colors.end.cgColor]
    }

    static func gradientEndpoints(direction: Direction) -> (start: CGPoint, end: CGPoint) {
        switch direction {
        case .up:
            return (start: CGPoint(x: 0.0, y: 1.0), end: CGPoint(x: 0.0, y: 0.0))
        case .left:
            return (start: CGPoint(x: 1.0, y: 0.0), end: CGPoint(x: 0.0, y: 0.0))
        case .down:
            return (start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: 0.0, y: 1.0))
        case .right:
            return (start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: 1.0, y: 0.0))
        }
    }

}
