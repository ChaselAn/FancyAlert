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
    case disabled
}

public struct FancyAlertAction {

    public var title: String
    public var style: FancyAlertActionStyle
    public var action: (() -> Void)?
    
}
