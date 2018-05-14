//
//  FancyAlertTextFieldHeaderView.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/5/14.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class FancyAlertTextFieldHeaderView: FancyAlertBaseHeaderView {

    override var headerHeight: CGFloat {
        return  super.headerHeight + (isEditable ? textFieldHeight + textFieldTopMargin : 0)
    }
    var markedColor: UIColor = UIColor.fancyAlertMarkedDefaultColor {
        didSet {
            textField?.textField.tintColor = textField?.cursorColor ?? markedColor
        }
    }

    private let labelSpace:CGFloat = 13
    private let bottomMargin: CGFloat = 28
    private let textFieldTopMargin: CGFloat = 25
    private let textFieldHeight: CGFloat = 30

    private var isEditable = false
    private var textField: FancyTextField?

    init(title: String?, message: String?, width: CGFloat, margin: CGFloat, editType: FancyAlertViewController.TempEditType) {
        switch editType {
        case .textField(let textField):
            self.textField = textField
            self.isEditable = true
        case .none:
            self.isEditable = false
        default:
            assertionFailure()
        }
        super.init(title: title, message: message, width: width, margin: margin)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func makeUI(title: String?, message: String?, width: CGFloat, outsideMargin: CGFloat) {
        super.makeUI(title: title, message: message, width: width, outsideMargin: outsideMargin)

        if isEditable, let fancyTextField = textField {
            let textField = fancyTextField.textField
            addSubview(textField)
            textField.text = fancyTextField.text
            textField.borderStyle = fancyTextField.borderStyle
            textField.font = fancyTextField.font
            textField.delegate = self
            textField.textColor = fancyTextField.textColor
            textField.textAlignment = fancyTextField.textAlignment
            textField.returnKeyType = fancyTextField.returnKeyType
            textField.frame = CGRect(x: margin, y: margin + titleLableHeight + (title != nil && message != nil ? labelSpace : 0) + messageLabelHeight + textFieldTopMargin, width: labelWidth, height: textFieldHeight)
            textField.tintColor = fancyTextField.cursorColor ?? markedColor
            textField.placeholder = fancyTextField.placeholder

            if fancyTextField.maxInputLength != nil {
                NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: .UITextFieldTextDidChange, object: nil)
            }
        }

    }

    @objc private func textFieldDidChange(notification: NSNotification) {

        guard let textField = textField?.textField, let tempText = textField.text as NSString?, let textMaxLength = self.textField?.maxInputLength else { return }

        let textCount = tempText.length
        let lang = textInputMode?.primaryLanguage
        if lang == "zh-Hans" {
            guard let selectedRange = textField.markedTextRange else {
                if textCount > textMaxLength {
                    let rangeIndex = tempText.rangeOfComposedCharacterSequence(at: textMaxLength)
                    if rangeIndex.length > 1 { //判断第三方输入法的emoji表情
                        textField.text = tempText.substring(to: rangeIndex.location)
                    } else {
                        let range = tempText.rangeOfComposedCharacterSequences(for: NSRange(location: 0, length: textMaxLength))
                        textField.text = tempText.substring(with: range)
                    }
                }
                return
            }
            if let _ = textField.position(from: selectedRange.start, offset: 0) {
                if textCount > textMaxLength {
                    let rangeIndex = tempText.rangeOfComposedCharacterSequence(at: textMaxLength)
                    if rangeIndex.length > 1 {
                        textField.text = tempText.substring(to: rangeIndex.location)
                    }
                }
            }
        } else {
            if textCount > textMaxLength {
                let rangeIndex = tempText.rangeOfComposedCharacterSequence(at: textMaxLength)
                if rangeIndex.length > 1 {
                    textField.text = tempText.substring(to: rangeIndex.location)
                } else {
                    let range = tempText.rangeOfComposedCharacterSequences(for: NSRange(location: 0, length: textMaxLength))
                    textField.text = tempText.substring(with: range)
                }
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension FancyAlertTextFieldHeaderView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
