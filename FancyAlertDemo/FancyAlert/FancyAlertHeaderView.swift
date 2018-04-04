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
        let progressAreaHeight = progress != nil ? progressHeight + progressVerticalMargin : 0
        return  margin + titleLableHeight + (title != nil && message != nil ? labelSpace : 0) + messageLabelHeight + (isEditable ? textFieldHeight + textFieldTopMargin : 0) + bottomMargin + progressAreaHeight
    }
    var markedColor: UIColor = UIColor.fancyAlertMarkedDefaultColor {
        didSet {
            textField.tintColor = markedColor
        }
    }

    private lazy var titleLabel = UILabel()
    private lazy var messageLabel = UILabel()
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .fancyAlertTrackTintColor
        progressView.progressTintColor = .fancyAlertProgressTintColor
        return progressView
    }()

    private var titleLableHeight: CGFloat = 0
    private var messageLabelHeight: CGFloat = 0

    private let labelSpace:CGFloat = 13
    private let margin: CGFloat = 25
    private let bottomMargin: CGFloat = 28
    private let textFieldTopMargin: CGFloat = 25
    private let textFieldHeight: CGFloat = 30
    private let progressHorizontalMargin: CGFloat = 29
    private let progressVerticalMargin: CGFloat = 22
    private let progressHeight: CGFloat = 4

    private let message: String?
    private let title: String?
    private let isEditable: Bool
    private let textField: UITextField!
    private let progress: Float?

    init(title: String?, message: String?, width: CGFloat, margin: CGFloat, isEditable: Bool, textField: UITextField, progress: Float?) {
        self.message = message
        self.title = title
        self.isEditable = isEditable
        self.textField = textField
        self.progress = progress
        super.init(frame: CGRect.zero)

        makeUI(title: title, message: message, width: width, outsideMargin: margin)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setProgress(_ progress: Float) {
        progressView.progress = progress
    }

    private func makeUI(title: String?, message: String?, width: CGFloat, outsideMargin: CGFloat) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.5
        paragraph.alignment = .center
        let labelWidth = width - 2 * outsideMargin - 2 * margin
        let progressWidth = width - 2 * outsideMargin - 2 * progressHorizontalMargin
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

            if progress != nil {
                addSubview(progressView)
                progressView.frame = CGRect(x: progressHorizontalMargin, y: margin + height + progressVerticalMargin, width: progressWidth, height: progressHeight)
            }
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

            if title == nil && progress != nil {
                addSubview(progressView)
                progressView.frame = CGRect(x: progressHorizontalMargin, y: margin + titleLableHeight + height + progressVerticalMargin, width: progressWidth, height: progressHeight)
            } else if title != nil && progress != nil {
                messageLabel.frame.origin.y += progressHeight + progressVerticalMargin
            }
        }

        if isEditable {
            addSubview(textField)
            textField.borderStyle = .none
            textField.font = UIFont.systemFont(ofSize: 16)
            textField.delegate = self
            textField.textColor = UIColor.fancyAlertMessageDefaultColor
            textField.textAlignment = .center
            textField.returnKeyType = .done
            textField.frame = CGRect(x: margin, y: margin + titleLableHeight + (title != nil && message != nil ? labelSpace : 0) + messageLabelHeight + textFieldTopMargin, width: labelWidth, height: textFieldHeight)
            textField.tintColor = markedColor

            if textField.fancy_maxInputLength != nil {
                NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: .UITextFieldTextDidChange, object: nil)
            }
        }

        if let progress = progress {
            progressView.progress = progress
        }
    }

    @objc private func textFieldDidChange(notification: NSNotification) {

        guard let tempText = textField.text as NSString?, let textMaxLength = textField.fancy_maxInputLength else { return }

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

extension FancyAlertHeaderView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
