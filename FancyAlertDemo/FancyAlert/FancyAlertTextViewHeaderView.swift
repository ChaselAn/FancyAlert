//
//  FancyAlertTextViewHeaderView.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/5/14.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class FancyAlertTextViewHeaderView: FancyAlertBaseHeaderView {

    var markedColor: UIColor = UIColor.fancyAlertMarkedDefaultColor {
        didSet {
            textView?.textView.tintColor = textView?.cursorColor ?? markedColor
        }
    }
    
    override var headerHeight: CGFloat {

        return super.headerHeight + (isEditable ? textViewHeight + textViewTopMargin + 2 * textViewTopPadding + limitLabelTotalHeight : 0)
    }

    private lazy var textViewBackgroundImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "textView_background"))
        return imageView
    }()

    private lazy var limitLabel: UILabel? = {
        guard let textView = textView else { return nil }
        let label = UILabel()
        label.textColor = textView.maxInputLimitLabelColor
        label.font = textView.maxInputLimitLabelFont
        label.textAlignment = .right
        if let inputLength = textView.maxInputLength {
            label.text = "\(inputLength)"
        }
        return label
    }()

    private let labelSpace:CGFloat = 13
    private let bottomMargin: CGFloat = 28
    private let textViewTopMargin: CGFloat = 25
    private var textViewHeight: CGFloat {
        return textView?.height ?? Config.textViewHeight
    }
    private let textViewTopPadding: CGFloat = 14
    private let textViewLeftPadding: CGFloat = 24
    private let limitLabelHeight: CGFloat = 12
    private let limitLabelTopMargin: CGFloat = 5

    private var isEditable = false
    private var textView: FancyTextView?
    private var isHaveLimit: Bool {
        return textView?.maxInputLength != nil && limitLabel != nil
    }
    private var limitLabelTotalHeight: CGFloat {
        return isHaveLimit ? limitLabelHeight + limitLabelTopMargin : 0
    }
    private var tempInputLength: Int = 0

    init(title: String?, message: String?, width: CGFloat, margin: CGFloat, editType: FancyAlertViewController.TempEditType) {
        switch editType {
        case .textView(let textView):
            self.textView = textView
            self.isEditable = true
        case .none:
            self.isEditable = false
        default:
            assertionFailure()
        }
        super.init(title: title, message: message, width: width, margin: margin)
        tempInputLength = textView?.maxInputLength ?? 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func makeUI(title: String?, message: String?, width: CGFloat, outsideMargin: CGFloat) {
        super.makeUI(title: title, message: message, width: width, outsideMargin: outsideMargin)

        guard isEditable, let fancyTextView = textView else { return }

        addSubview(textViewBackgroundImageView)
        textViewBackgroundImageView.frame = CGRect(x: margin, y: margin + titleLableHeight + (title != nil && message != nil ? labelSpace : 0) + messageLabelHeight + textViewTopMargin, width: labelWidth, height: textViewHeight + 2 * textViewTopPadding + limitLabelTotalHeight)

        let tempTextView = fancyTextView.textView
        addSubview(tempTextView)
        tempTextView.backgroundColor = .clear
        tempTextView.tintColor = fancyTextView.cursorColor ?? markedColor
        tempTextView.frame = CGRect(x: margin + textViewLeftPadding, y: margin + titleLableHeight + (title != nil && message != nil ? labelSpace : 0) + messageLabelHeight + textViewTopMargin + textViewTopPadding, width: labelWidth - 2 * textViewLeftPadding, height: textViewHeight)
        tempTextView.delegate = self

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = fancyTextView.lineSpacing
        paragraphStyle.alignment = fancyTextView.textAlignment
        tempTextView.attributedText = NSAttributedString(string: fancyTextView.text ?? "",
                                                         attributes: [.paragraphStyle: paragraphStyle,
                                                                      .foregroundColor: fancyTextView.textColor,
                                                                      .font: fancyTextView.font])

        if fancyTextView.maxInputLength != nil, let limitLabel = limitLabel {
            addSubview(limitLabel)
            limitLabel.frame = CGRect(x: tempTextView.frame.origin.x, y: tempTextView.frame.maxY + limitLabelTopMargin, width: tempTextView.bounds.width, height: limitLabelHeight)
        }
    }
}

extension FancyAlertTextViewHeaderView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        guard let tempText = textView.text, let textMaxLength = self.textView?.maxInputLength else { return }
        guard let fancyTextView = self.textView else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = fancyTextView.lineSpacing
        paragraphStyle.alignment = fancyTextView.textAlignment
        let attributes: [NSAttributedStringKey: Any] = [.paragraphStyle: paragraphStyle,
                                                        .foregroundColor: fancyTextView.textColor,
                                                        .font: fancyTextView.font]

        let textCount = tempText.count
        let lang = textInputMode?.primaryLanguage
        if lang == "zh-Hans" {
            guard let _ = textView.markedTextRange else {
                if textCount > textMaxLength {
                    textView.attributedText = NSAttributedString(string: String(tempText.prefix(textMaxLength)), attributes: attributes)
                    limitLabel?.text = "\(max(0, tempInputLength - String(tempText.prefix(textMaxLength)).count))"
                } else {
                    textView.attributedText = NSAttributedString(string: tempText, attributes: attributes)
                    limitLabel?.text = "\(max(0, tempInputLength - tempText.count))"
                }
                return
            }
        } else {
            if textCount > textMaxLength {
                textView.attributedText = NSAttributedString(string: String(tempText.prefix(textMaxLength)), attributes: attributes)
                limitLabel?.text = "\(max(0, tempInputLength - String(tempText.prefix(textMaxLength)).count))"
            } else {
                textView.attributedText = NSAttributedString(string: tempText, attributes: attributes)
                limitLabel?.text = "\(max(0, tempInputLength - tempText.count))"
            }

        }
    }
}
