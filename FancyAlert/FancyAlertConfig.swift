//
//  FancyAlertConfig.swift
//  FancyAlert
//
//  Created by ancheng on 2018/12/4.
//  Copyright © 2018 ancheng. All rights reserved.
//

import Foundation

public class FancyAlertConfig {

    public static var backgroundColor = UIColor.white
    public static var separatorHeight = 1 / UIScreen.main.scale
}

// MARK:- alert config
extension FancyAlertConfig {

    public static var alertTitleDefaultColor: UIColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)  // 333333
    public static var alertMessageDefaultColor: UIColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)  // 4a4a4a

    public static var alertSeparatorColor: UIColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)  // ececec

    public static var alertProgressTintColor: UIColor = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1)  // c3c3c3
    public static var alertTrackTintColor: UIColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)  // e3e3e3

    public static var alertCellSelectedColor: UIColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)  // ededed

    public static var textViewHeight: CGFloat = 115
    public static var textViewLineSpacing: CGFloat = 6

    public static var alertContentInset: FancyAlertContentEdgeInsets = FancyAlertContentEdgeInsets(left: 39, right: 39) 
}

// MARK:- actionSheet config
extension FancyAlertConfig {

    public static var actionSheetTitleDefaultColor: UIColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)  // 979797
    public static var actionSheetMessageDefaultColor: UIColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)  // 979797

    public static var actionSheetNormalActionDefaultColor: UIColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)  // 333333
    public static var actionSheetMarkedActionDefaultColor: UIColor = #colorLiteral(red: 1, green: 0.1882352941, blue: 0.2862745098, alpha: 1)  // FF3049
    public static var actionSheetDisabledActionDefaultColor: UIColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)  // 979797
    public static var actionSheetCancelActionDefaultColor: UIColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)  // 979797

    public static var actionSheetCellSelectedColor: UIColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)  // ededed

    public static var actionSheetContentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 13, bottom: 13, right: 13)

    @available(iOS 11.0, *)
    public static var actionSheetContentInsetAdjustmentBehavior: FancyAlertViewController.ContentInsetAdjustmentBehavior = .always
}
