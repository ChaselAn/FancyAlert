//
//  FancyTextField.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/5/14.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

public class FancyTextField {

    public var text: String?
    public var maxInputLength: Int?
    public var borderStyle: UITextBorderStyle = .none
    public var font = UIFont.systemFont(ofSize: 16)
    public var textColor = UIColor.fancyAlertMessageDefaultColor
    public var textAlignment: NSTextAlignment = .center
    public var returnKeyType: UIReturnKeyType = .done
    public var cursorColor: UIColor?
    public var placeholder: String?

    let textField = UITextField()
}
