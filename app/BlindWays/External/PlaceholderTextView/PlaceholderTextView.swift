//
//  PlaceholderTextView.swift
//  BlindWays
//
//  Created by Derek Ostrander on 6/8/16.
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

public class PlaceholderTextView: UITextView, PlaceholderConfigurable {

    let placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.textColor = .lightGray
        placeholderLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        return placeholderLabel
    }()

    public var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    public var attributedPlaceholder: NSAttributedString? {
        didSet {
            placeholderLabel.attributedText = attributedPlaceholder
        }
    }

    public var placeholderTextColor: UIColor? = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
        }
    }

    override public var textContainerInset: UIEdgeInsets {
        didSet {
            adjustPlaceholder()
        }
    }

    override public var text: String! {
        didSet {
            adjustPlaceholder()
        }
    }

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureTextView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureTextView()
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.UITextViewTextDidChange,
                                                  object: nil)
    }

    fileprivate func configureTextView() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        addSubview(placeholderLabel)
        adjustPlaceholder()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: Notification.Name.UITextViewTextDidChange,
                                               object: nil)
    }

    func textDidChange(_ notification: Notification) {
        if let object = notification.object as? UITextField, object == self {
            adjustPlaceholder()
        }
    }

}
