//
//  FancyAlertHeaderView.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/21.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class FancyAlertHeaderView: UIView {

    var headerHeight: CGFloat {
        return  margin + titleLableHeight + (title != nil && message != nil ? labelSpace : 0) + messageLabelHeight + (isEditable ? textFieldHeight + textFieldTopMargin : 0) + bottomMargin
    }
    var markedColor: UIColor = UIColor.fancyAlertMarkedDefaultColor {
        didSet {
            textField.tintColor = markedColor
        }
    }

    private lazy var titleLabel = UILabel()
    private lazy var messageLabel = UILabel()

    private var titleLableHeight: CGFloat = 0
    private var messageLabelHeight: CGFloat = 0

    private let labelSpace:CGFloat = 13
    private let margin: CGFloat = 25
    private let bottomMargin: CGFloat = 20
    private let textFieldTopMargin: CGFloat = 25
    private let textFieldHeight: CGFloat = 30

    private let message: String?
    private let title: String?
    private let isEditable: Bool
    private let textField: UITextField!

    init(title: String?, message: String?, width: CGFloat, margin: CGFloat, isEditable: Bool, textField: UITextField) {
        self.message = message
        self.title = title
        self.isEditable = isEditable
        self.textField = textField
        super.init(frame: CGRect.zero)

        makeUI(title: title, message: message, width: width, outsideMargin: margin)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeUI(title: String?, message: String?, width: CGFloat, outsideMargin: CGFloat) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.5
        paragraph.alignment = .center
        let labelWidth = width - 2 * outsideMargin - 2 * margin
        if let title = title {
            let attributes: [NSAttributedStringKey: Any] = [.paragraphStyle: paragraph,
                                                            .font: UIFont.systemFont(ofSize: 17, weight: .medium),
                                                            .foregroundColor: UIColor.fancyAlertTitleDefaultColor]
            let attributeString = NSMutableAttributedString(string: title,
                                                            attributes: attributes)
            titleLabel.attributedText = attributeString
            titleLabel.numberOfLines = 0
            addSubview(titleLabel)
            let height = title.fancyAlert_getHeight(maxWidth: labelWidth, attributes: attributes)
            titleLableHeight = height
            titleLabel.frame = CGRect(x: margin, y: margin, width: labelWidth, height: height)
        }

        if let message = message {
            let attributes: [NSAttributedStringKey: Any] = [.paragraphStyle: paragraph,
                                                            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                                                            .foregroundColor: UIColor.fancyAlertMessageDefaultColor]
            let attributeString = NSMutableAttributedString(string: message,
                                                            attributes: attributes)
            messageLabel.attributedText = attributeString
            messageLabel.numberOfLines = 0
            addSubview(messageLabel)
            let height = message.fancyAlert_getHeight(maxWidth: labelWidth, attributes: attributes)
            messageLabelHeight = height
            messageLabel.frame = CGRect(x: margin, y: margin + titleLableHeight + (title != nil ? labelSpace : 0), width: labelWidth, height: height)
        }

        if isEditable {
            addSubview(textField)
            textField.borderStyle = .none
            textField.font = UIFont.systemFont(ofSize: 16)
            textField.delegate = self
            textField.textColor = UIColor.fancyAlertMessageDefaultColor
            textField.textAlignment = .center
            textField.frame = CGRect(x: margin, y: margin + titleLableHeight + (title != nil && message != nil ? labelSpace : 0) + messageLabelHeight + textFieldTopMargin, width: labelWidth, height: textFieldHeight)
            textField.tintColor = markedColor
        }
    }

}

extension FancyAlertHeaderView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
