//
//  FancyActionSheetHeaderView.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/21.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class FancyActionSheetHeaderView: UIView {

    var headerHeight: CGFloat {
        return  topMargin + titleLableHeight + (title != nil && message != nil ? labelSpace : 0) + messageLabelHeight + bottomMargin
    }

    private lazy var titleLabel = UILabel()
    private lazy var messageLabel = UILabel()

    private var titleLableHeight: CGFloat = 0
    private var messageLabelHeight: CGFloat = 0

    private let labelSpace:CGFloat = 13
    private let horizontalMargin: CGFloat = 25
    private let topMargin: CGFloat = 10
    private let bottomMargin: CGFloat = 10

    private let message: String?
    private let title: String?

    init(title: String?, message: String?, width: CGFloat, inset: UIEdgeInsets) {
        self.message = message
        self.title = title
        super.init(frame: CGRect.zero)

        makeUI(title: title, message: message, width: width, outsideInset: inset)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeUI(title: String?, message: String?, width: CGFloat, outsideInset: UIEdgeInsets) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.5
        paragraph.alignment = .center
        if let title = title {
            let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraph,
                                                            .font: UIFont.systemFont(ofSize: 13, weight: .medium),
                                                            .foregroundColor: FancyAlertConfig.actionSheetTitleDefaultColor]
            let attributeString = NSMutableAttributedString(string: title,
                                                            attributes: attributes)
            titleLabel.attributedText = attributeString
            titleLabel.numberOfLines = 0
            addSubview(titleLabel)
            let labelWidth = width - outsideInset.left - outsideInset.right - 2 * horizontalMargin
            let height = title.fancyAlert_getHeight(maxWidth: labelWidth, attributes: attributes)
            titleLableHeight = height
            titleLabel.frame = CGRect(x: horizontalMargin, y: topMargin, width: labelWidth, height: height)
        }

        if let message = message {
            let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraph,
                                                            .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                                                            .foregroundColor: FancyAlertConfig.actionSheetMessageDefaultColor]
            let attributeString = NSMutableAttributedString(string: message,
                                                            attributes: attributes)
            messageLabel.attributedText = attributeString
            messageLabel.numberOfLines = 0
            addSubview(messageLabel)
            let labelWidth = width - outsideInset.left - outsideInset.right - 2 * horizontalMargin
            let height = message.fancyAlert_getHeight(maxWidth: labelWidth, attributes: attributes)
            messageLabelHeight = height
            messageLabel.frame = CGRect(x: horizontalMargin, y: topMargin + titleLableHeight + (title != nil ? labelSpace : 0), width: labelWidth, height: height)
        }
    }
}
