//
//  FancyTextView.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/5/14.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

public class FancyTextView: UITextView {

    public var height: CGFloat = FancyAlertConfig.textViewHeight
    public var maxInputLength: Int?
    public var cursorColor: UIColor?
    public var lineSpacing: CGFloat = FancyAlertConfig.textViewLineSpacing

    // 以下属性maxInputLength不为nil时有效
    public var maxInputLimitLabelColor = FancyAlertConfig.alertProgressTintColor
    public var maxInputLimitLabelFont = UIFont.systemFont(ofSize: 12)

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        font = UIFont.systemFont(ofSize: 14)
        textColor = FancyAlertConfig.alertMessageDefaultColor
        textAlignment = .left
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
