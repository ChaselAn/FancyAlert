//
//  FancyTextView.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/5/14.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

public class FancyTextView {

    public var text: String?
    public var height: CGFloat = 116
    public var maxInputLength: Int?
    public var font = UIFont.systemFont(ofSize: 14)
    public var textColor = UIColor.fancyAlertMessageDefaultColor
    public var textAlignment: NSTextAlignment = .left
    public var cursorColor: UIColor?
    public var lineSpacing: CGFloat = 10

    // 以下属性maxInputLength不为nil时有效
    public var maxInputLimitLabelColor = UIColor.fancyAlertProgressTintColor
    public var maxInputLimitLabelFont = UIFont.systemFont(ofSize: 12)

    let textView = UITextView()
}
