//
//  FancyTextField.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/5/14.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

public class FancyTextField: UITextField {

    public var maxInputLength: Int?
    public var cursorColor: UIColor?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 16)
        textColor = UIColor.fancyAlertMessageDefaultColor
        textAlignment = .center
        returnKeyType = .done
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
