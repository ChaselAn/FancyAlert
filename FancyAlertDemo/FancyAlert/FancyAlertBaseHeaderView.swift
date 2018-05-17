//
//  FancyAlertBaseHeaderView.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/5/11.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class FancyAlertBaseHeaderView: UIView {

    var message: String? {
        didSet {
            if message != tempMessage {
                tempMessage = message
                makeUI(title: title, message: message, width: width, outsideMargin: outsideMargin)
                heightChanged?()
            }
        }
    }
    var title: String? {
        didSet {
            if title != tempTitle {
                tempTitle = title
                makeUI(title: title, message: message, width: width, outsideMargin: outsideMargin)
                heightChanged?()
            }
        }
    }

    var heightChanged: (() -> Void)?

    var headerHeight: CGFloat {
        return  margin + titleLableHeight + (tempTitle != nil && tempMessage != nil ? labelSpace : 0) + messageLabelHeight + bottomMargin
    }

    private lazy var titleLabel = UILabel()
    private(set) lazy var messageLabel = UILabel()

    private(set) var titleLableHeight: CGFloat = 0
    private(set) var messageLabelHeight: CGFloat = 0

    private let labelSpace:CGFloat = 5
    private(set) var margin: CGFloat = 20
    private let bottomMargin: CGFloat = 28
    private let textFieldTopMargin: CGFloat = 25
    private let textFieldHeight: CGFloat = 30
    var labelWidth: CGFloat {
        return width - 2 * outsideMargin - 2 * margin
    }

    private var tempTitle: String?
    private var tempMessage: String?
    private(set) var width: CGFloat
    private(set) var outsideMargin: CGFloat

    init(title: String?, message: String?, width: CGFloat, margin: CGFloat) {
        self.tempMessage = message
        self.tempTitle = title
        self.width = width
        self.outsideMargin = margin
        super.init(frame: CGRect.zero)

        makeUI(title: tempTitle, message: tempMessage, width: width, outsideMargin: margin)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeUI(title: String?, message: String?, width: CGFloat, outsideMargin: CGFloat) {
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

        } else {
            titleLableHeight = 0
            titleLabel.removeFromSuperview()
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

        } else {
            messageLabelHeight = 0
            messageLabel.removeFromSuperview()
        }

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
