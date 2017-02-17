//
//  Appearance.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/9/16.
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

class Appearance {

    static let shared = Appearance()

    static let defaultEmptyStateStyle = EmptyStateStyle(
        backgroundColor: .clear,
        imageTintColor: .white,
        messageTintColor: .white,
        messageFont: UIFont.preferredFont(forTextStyle: .headline),
        actionTintColor: Colors.Common.manilla,
        actionFont:  UIFont.preferredFont(forTextStyle: .headline))

    func configure() {
        let navProxy = UINavigationBar.appearance()
        Appearance.styleNavBar(navProxy, color: Colors.Common.marineBlue)

        UISegmentedControl.appearance().tintColor = UIColor.white
        UISegmentedControl.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName: UIColor.white,
            ], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName: Colors.Common.marineBlue,
            ], for: .selected)

    }

    static func resetNavBarAppearance() {
        let navProxy = UINavigationBar.appearance()
        navProxy.barTintColor = nil
        navProxy.barStyle = .default
        navProxy.tintColor = Colors.Common.darkGrassGreen
        navProxy.setBackgroundImage(nil, for: .default)
        navProxy.shadowImage = nil
    }

    static func styleNavBar(_ navProxy: UINavigationBar, color: UIColor) {
        navProxy.barStyle = .black
        navProxy.tintColor = .white
        navProxy.isTranslucent = false
        navProxy.setBackgroundImage(UIImage.solid(color: color, size: CGSize(width: 1, height: 1)), for: .default)
        navProxy.shadowImage = UIImage()
    }

    static func modalButton(color: UIColor, textColor: UIColor = Colors.Common.white) -> SolidColorButton {
        let button = SolidColorButton(titleColor: textColor, backgroundColor: color)
        button.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .vertical)
        button.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        button.widthAnchor == 220
        button.heightAnchor >= 56
        button.layer.cornerRadius = 4.0
        button.layer.masksToBounds = true

        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        return button
    }

    static func printDynamicTextStyleSizes() {

        // As of iOS 9.3.2:
        // Title1   = 28.0 pt .SFUIDisplay-Light
        // Title2   = 22.0 pt .SFUIDisplay-Regular
        // Title3   = 20.0 pt .SFUIDisplay-Regular
        // Headline = 17.0 pt .SFUIText-Semibold
        // Subhead  = 15.0 pt .SFUIText-Regular
        // Body     = 17.0 pt .SFUIText-Regular
        // Callout  = 16.0 pt .SFUIText-Regular
        // Footnote = 13.0 pt .SFUIText-Regular
        // Caption1 = 12.0 pt .SFUIText-Regular
        // Caption2 = 11.0 pt .SFUIText-Regular

        let styles = [
            UIFontTextStyle.title1,
            UIFontTextStyle.title2,
            UIFontTextStyle.title3,
            UIFontTextStyle.headline,
            UIFontTextStyle.subheadline,
            UIFontTextStyle.body,
            UIFontTextStyle.callout,
            UIFontTextStyle.footnote,
            UIFontTextStyle.caption1,
            UIFontTextStyle.caption2,
        ]

        print("------ Dynamic Text Style Sizes ------")
        for style in styles {
            let font = UIFont.preferredFont(forTextStyle: style)
            print("\(style) - \(font.pointSize) pt \(font.fontName)")
        }
    }

}

extension Appearance: AppLifecycleConfigurable {

    func onDidLaunch(_ application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        configure()
    }

}

extension UIImage {

    class func solid(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }

}
