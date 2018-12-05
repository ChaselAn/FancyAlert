//
//  FancyTextField.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/5/14.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

public class FancyTextField: UITextField {

    public enum Style {
        case transparent
        case gray
        case transparentAndSizeFit
    }

    public var style: Style = .transparent {
        didSet {
            updateStyle()
        }
    }
    public var maxInputLength: Int?
    public var cursorColor: UIColor?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        updateStyle()
        setupTextChangeNotification()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateStyle() {
        switch style {
        case .transparent:
            setTransparentStyle()
            textAlignment = .center
        case .gray:
            backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            layer.borderWidth = 0.5
            layer.borderColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
            layer.cornerRadius = 2
            layer.masksToBounds = true
            font = UIFont.systemFont(ofSize: 13)
            textColor = FancyAlertConfig.alertMessageDefaultColor
            textAlignment = .left
            returnKeyType = .done
            let textFieldLeftView = UIView()
            textFieldLeftView.frame = CGRect(x: 0, y: 0, width: 6, height: 0)
            leftView = textFieldLeftView
            leftViewMode = .always
        case .transparentAndSizeFit:
            setTransparentStyle()
            textAlignment = .right
        }
    }

    private func setTransparentStyle() {
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 16)
        textColor = FancyAlertConfig.alertMessageDefaultColor
        returnKeyType = .done
    }

    func setupTextChangeNotification() {
        NotificationCenter.default.addObserver(
            forName: UITextField.textDidChangeNotification,
            object: self,
            queue: nil) { (notification) in
                UIView.animate(withDuration: 0.05, animations: {
                    self.invalidateIntrinsicContentSize()
                })
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override public var intrinsicContentSize: CGSize {
        if isEditing {
            if let text = text,
                !text.isEmpty {
                // Convert to NSString to use size(attributes:)
                let string = text as NSString
                // Calculate size for current text
                var size = string.size(withAttributes: typingAttributes)
                // Add margin to calculated size
                size.width += 10
                return size
            } else {
                // You can return some custom size in case of empty string
                return super.intrinsicContentSize
            }
        } else {
            return super.intrinsicContentSize
        }
    }
}
