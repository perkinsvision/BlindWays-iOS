//
//  UIFont+Extensions.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 5/26/16.
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

extension UIFont {

    enum FontWeight {
        case ultraLight
        case thin
        case light
        case regular
        case medium
        case semibold
        case bold
        case heavy
        case black

        var CGFloatValue: CGFloat {
            switch self {
            case .ultraLight: return UIFontWeightUltraLight
            case .thin: return UIFontWeightThin
            case .light: return UIFontWeightLight
            case .regular: return UIFontWeightRegular
            case .medium: return UIFontWeightMedium
            case .semibold: return UIFontWeightSemibold
            case .bold: return UIFontWeightBold
            case .heavy: return UIFontWeightHeavy
            case .black: return UIFontWeightBlack
            }
        }
    }

    static func dynamicSize(style: UIFontTextStyle, weight: FontWeight) -> UIFont {
        let pointSize = UIFont.preferredFont(forTextStyle: style).pointSize
        return UIFont.systemFont(ofSize: pointSize, weight: weight.CGFloatValue)
    }

}
