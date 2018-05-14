//
//  FancyAlertProgressHeaderView.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/5/11.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class FancyAlertProgressHeaderView: FancyAlertBaseHeaderView {

    var progress: Float? {
        didSet {
            if progress != tempProgress {
                tempProgress = progress
                makeUI(title: title, message: message, width: width, outsideMargin: outsideMargin)
                heightChanged?()
            }
        }
    }

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .fancyAlertTrackTintColor
        progressView.progressTintColor = .fancyAlertProgressTintColor
        return progressView
    }()

    private let progressHorizontalMargin: CGFloat = 29
    private let progressVerticalMargin: CGFloat = 22
    private let progressHeight: CGFloat = 4
    private var tempProgress: Float?

    override var headerHeight: CGFloat {
        let progressAreaHeight = tempProgress != nil ? progressHeight + progressVerticalMargin : 0
        return  super.headerHeight + progressAreaHeight
    }

    init(title: String?, message: String?, width: CGFloat, margin: CGFloat, progress: Float?) {
        self.tempProgress = progress
        super.init(title: title, message: message, width: width, margin: margin)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func makeUI(title: String?, message: String?, width: CGFloat, outsideMargin: CGFloat) {
        super.makeUI(title: title, message: message, width: width, outsideMargin: outsideMargin)

        let progressWidth = width - 2 * outsideMargin - 2 * progressHorizontalMargin
        if title != nil {
            if tempProgress != nil {
                addSubview(progressView)
                progressView.frame = CGRect(x: progressHorizontalMargin, y: margin + titleLableHeight + progressVerticalMargin, width: progressWidth, height: progressHeight)
            } else {
                progressView.removeFromSuperview()
            }
        }


        if message != nil {
            if title == nil && tempProgress != nil {
                addSubview(progressView)
                progressView.frame = CGRect(x: progressHorizontalMargin, y: margin + titleLableHeight + messageLabelHeight + progressVerticalMargin, width: progressWidth, height: progressHeight)
            } else if title != nil && tempProgress != nil {
                messageLabel.frame.origin.y += progressHeight + progressVerticalMargin
            } else {
                progressView.removeFromSuperview()
            }
        }

        if let progress = tempProgress {
            progressView.progress = progress
        }
    }

    func setProgress(_ progress: Float) {
        progressView.progress = progress
    }
}
