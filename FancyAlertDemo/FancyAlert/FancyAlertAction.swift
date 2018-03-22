//
//  FancyAlertAction.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/20.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

public enum FancyAlertActionStyle {
    case normal
    case cancel
    case marked 
    case disabled // not dismiss when clicked, only used in actionsheet
}

public class FancyAlertAction {

    public var title: String
    public var style: FancyAlertActionStyle
    public var handler: (() -> Void)?
    public var isEnabled: Bool = true {
        didSet {
            if isEnabled != oldValue {
                enabledDidChange?(isEnabled)
            }
        }
    }

    var enabledDidChange: ((Bool) -> Void)?
    
    public init(title: String, style: FancyAlertActionStyle, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    
}
