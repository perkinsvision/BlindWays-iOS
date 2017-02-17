//
//  ClueSlotSelectionControl.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 4/25/16.
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

class ClueSlotSelectionControl: UIControl {

    static let numberOfSlots = 5

    fileprivate var unselectedLayerView: UIView!
    fileprivate var selectedLayerView: UIView!
    fileprivate var buttonHolderView: UIView!
    fileprivate var internalLayoutInfo: LayoutInfo?

    init() {
        super.init(frame: CGRect.zero)
        configureView()
        selectSlot(at: ClueSlot.busStopSign.rawValue, animated: false, notifyAction: false)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        invalidateLayoutInfo()

        layOutIcons(in: selectedLayerView)
        layOutIcons(in: unselectedLayerView)
        layoutButtons()

        maskSlot(at: selectedIndex)
    }

    func setSlotFilled(at index: Int, filled: Bool) {
        if let imageView = unselectedLayerView.subviewWithTag(index) as? UIImageView {
            imageView.image = filled ? Asset.icnCluenavChecked.image : Asset.icnCluenavDot.image
        }

        if let imageView = selectedLayerView.subviewWithTag(index) as? UIImageView {
            imageView.image = filled ? Asset.icnCluenavCheckedOn.image : Asset.icnCluenavDotOn.image
        }
    }

    func selectSlot(at index: Int, animated: Bool = true, notifyAction: Bool = true) {
        if animated {
            let snapshot = self.snapshotView(afterScreenUpdates: true)
            selectedLayerView.addSubview(snapshot!)
            maskSlot(at: index)

            UIView.animate(withDuration: 0.3, animations: {
                snapshot?.alpha = 0.0
            }, completion: { _ in
                snapshot?.removeFromSuperview()
            })
        } else {
            maskSlot(at: index)
        }

        selectButton(at: index)

        if notifyAction {
            sendActions(for: .valueChanged)
        }
    }

    var selectedIndex: Int {
        for (index, view) in buttonHolderView.subviews.enumerated() {
            if let button = view as? UIButton, button.isSelected {
                return index
            }
        }

        return ClueSlot.busStopSign.rawValue
    }

}

private extension ClueSlotSelectionControl {

    // MARK: Layout

    /*
     screen: 375

     rect:  41
     inter: 44 start %: .109
     rect:  48
     inter: 20 start %: .237
     rect:  72
     */

    struct Constants {

        static let spacing1StartPercent: CGFloat = 0.109
        static let spacing1Width: CGFloat = 44.0
        static let spacing2StartPercent: CGFloat = 0.357
        static let spacing2Width: CGFloat = 20.0
        static let edgeIconCenterAdjust: CGFloat = 15.0

    }

    struct LayoutInfo {

        let rects: [CGRect]
        let iconCenters: [CGPoint]
        let buttonRects: [CGRect]
        let maskPaths: [[CGPoint]]

    }

    var layoutInfo: LayoutInfo {
        get {
            if let info = internalLayoutInfo {
                return info
            } else {
                let info = createLayoutInfo()
                internalLayoutInfo = info
                return info
            }
        }
        set {
            internalLayoutInfo = newValue
        }
    }

    func createLayoutInfo() -> LayoutInfo {
        // swiftlint:disable operator_usage_whitespace
        let viewWidth  = self.bounds.size.width
        let viewHeight = self.bounds.size.height

        let rect1      = CGRect(x: 0, y: 0, width: viewWidth * Constants.spacing1StartPercent, height: viewHeight)
        let spacing1   = CGRect(x: rect1.width, y: 0, width: Constants.spacing1Width, height: viewHeight)

        let rect2X     = spacing1.maxX
        let rect2      = CGRect(x: rect2X, y: 0, width: (viewWidth * Constants.spacing2StartPercent) - rect2X, height: viewHeight)
        let spacing2   = CGRect(x: rect2.maxX, y: 0, width: Constants.spacing2Width, height: viewHeight)

        let centerW    = viewWidth - ((rect1.width + spacing1.width + rect2.width + spacing2.width) * 2.0)
        let centerRect = CGRect(x: spacing2.maxX, y: 0, width: centerW, height: viewHeight)

        let spacing3   = CGRect(x: centerRect.maxX, y: 0, width: spacing2.width, height: viewHeight)
        let rect3      = CGRect(x: spacing3.maxX, y: 0, width: rect2.width, height: viewHeight)

        let spacing4   = CGRect(x: rect3.maxX, y: 0, width: spacing1.width, height: viewHeight)
        let rect4      = CGRect(x: spacing4.maxX, y: 0, width: rect1.width, height: viewHeight)
        // swiftlint:enable operator_usage_whitespace

        let rects = [
            rect1,
            spacing1,
            rect2,
            spacing2,
            centerRect,
            spacing3,
            rect3,
            spacing4,
            rect4,
        ]

        let halfViewHeight = viewHeight / 2.0
        let halfWidth1 = spacing1.width / 2.0
        let halfWidth2 = spacing2.width / 2.0
        let halfWidth3 = spacing3.width / 2.0
        let halfWidth4 = spacing4.width / 2.0

        let iconCenters = [
            CGPoint(x: (spacing1.maxX / 2.0) - Constants.edgeIconCenterAdjust, y: halfViewHeight),
            CGPoint(x: rect2.origin.x + (rect2.width * 0.38), y: halfViewHeight),
            CGPoint(x: centerRect.origin.x + (centerRect.width / 2.0), y: halfViewHeight),
            CGPoint(x: rect3.origin.x + (rect3.width * 0.62), y: halfViewHeight),
            CGPoint(x: (spacing4.origin.x + (viewWidth - spacing4.origin.x) / 2.0) + Constants.edgeIconCenterAdjust, y: halfViewHeight),
        ]

        let buttonRects = [
            CGRect(x: 0, y: 0, width: rect1.width + halfWidth1, height: viewHeight),
            CGRect(x: spacing1.midX, y: 0, width: halfWidth1 + rect2.width + halfWidth2, height: viewHeight),
            CGRect(x: spacing2.midX, y: 0, width: halfWidth2 + centerRect.width + halfWidth3, height: viewHeight),
            CGRect(x: spacing3.midX, y: 0, width: halfWidth3 + rect3.width + halfWidth4, height: viewHeight),
            CGRect(x: spacing4.midX, y: 0, width: halfWidth4 + rect4.width, height: viewHeight),
            ]

        let maskPaths = [
            [ rect1.topLeft, rect1.bottomLeft, rect1.bottomRight, spacing1.topRight ],
            [ spacing1.bottomLeft, spacing1.topRight, spacing2.topRight, spacing2.bottomLeft ],
            [ spacing2.bottomLeft, spacing2.topRight, spacing3.topLeft, spacing3.bottomRight ],
            [ spacing3.topLeft, spacing3.bottomRight, spacing4.bottomRight, spacing4.topLeft ],
            [ spacing4.topLeft, spacing4.bottomRight, rect4.bottomRight, rect4.topRight ],
        ]

        return LayoutInfo(rects: rects, iconCenters: iconCenters, buttonRects: buttonRects, maskPaths: maskPaths)
    }

    func invalidateLayoutInfo() {
        internalLayoutInfo = nil
    }

    // MARK: View

    func configureView() {
        unselectedLayerView = viewWithBackgroundColor(Colors.Common.grayAlt, isSelectedLayer: false)
        addSubview(unselectedLayerView)

        selectedLayerView = viewWithBackgroundColor(Colors.Common.darkGrassGreen, isSelectedLayer: true)
        addSubview(selectedLayerView)

        addButtons()
    }

    func viewWithBackgroundColor(_ backgroundColor: UIColor, isSelectedLayer: Bool) -> UIView {
        let view = UIView(frame: self.bounds)

        view.backgroundColor = backgroundColor

        for index in 0..<ClueSlotSelectionControl.numberOfSlots {
            let iconView = UIImageView(frame: CGRect.zero)
            iconView.tag = index
            iconView.backgroundColor = .clear
            iconView.image = isSelectedLayer ? Asset.icnCluenavDotOn.image : Asset.icnCluenavDot.image
            iconView.contentMode = .center
            view.addSubview(iconView)
        }

        return view
    }

    func layOutIcons(in view: UIView) {
        view.frame = self.bounds

        for (index, iconCenter) in layoutInfo.iconCenters.enumerated() {
            if let imageView = view.subviewWithTag(index) {
                imageView.center = iconCenter
            }
        }
    }

    // MARK: Masking

    func maskSlot(at index: Int) {
        guard selectedLayerView.frame != CGRect.zero else {
            return
        }

        let points = layoutInfo.maskPaths[index]
        let maskLayer = CAShapeLayer()
        maskLayer.path = pathWithPoints(points).cgPath
        selectedLayerView.layer.mask = maskLayer
    }

    func pathWithPoints(_ points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: points[0])
        for index in 1 ..< points.count {
            path.addLine(to: points[index])
        }

        path.close()

        return path
    }

    // MARK: Buttons

    func addButtons() {
        buttonHolderView = UIView(frame: CGRect.zero)
        addSubview(buttonHolderView)

        for index in 0 ..< ClueSlotSelectionControl.numberOfSlots {
            let button = UIButton(type: .custom)
            button.tag = index
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(ClueSlotSelectionControl.handleButtonTapped(_:)), for: .touchUpInside)
            buttonHolderView.addSubview(button)

            if let slot = ClueSlot(rawValue: index) {
                button.accessibilityLabel = slot.localizedAccessibilityTitle
            }
        }
    }

    func layoutButtons() {
        buttonHolderView.frame = self.bounds

        let info = layoutInfo
        for (index, rect) in info.buttonRects.enumerated() {
            if let button = buttonHolderView.subviewWithTag(index) {
                button.frame = rect
            }
        }

    }

    @objc func handleButtonTapped(_ button: UIButton) {
        selectSlot(at: button.tag)
    }

    func selectButton(at index: Int) {
        for case let button as UIButton in buttonHolderView.subviews {
            button.isSelected = button.tag == index
        }
    }

}

private extension UIView {

    func subviewWithTag(_ tag: Int) -> UIView? {
        for view in subviews {
            if view.tag == tag {
                return view
            }
        }

        return nil
    }

}
