//
//  FancyAlertUtil.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/22.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

extension UIColor {

    public static var fancyAlertTitleDefaultColor: UIColor { return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) } // 333333
    public static var fancyAlertMessageDefaultColor: UIColor { return #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1) } // 4a4a4a
    public static var fancyActionSheetTitleDefaultColor: UIColor { return #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1) } // 979797

    public static var fancyAlertNormalDefaultColor: UIColor { return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) } // 333333
    public static var fancyAlertMarkedDefaultColor: UIColor { return #colorLiteral(red: 1, green: 0.1882352941, blue: 0.2862745098, alpha: 1) } // FF3049
    public static var fancyAlertDisabledDefaultColor: UIColor { return #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1) } // 979797

    public static var fancyAlertSeparatorColor: UIColor { return #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1) } // ececec
    public static var fancyActionSheetSelectedColor: UIColor { return #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1) } // ededed
}

extension String {

    func fancyAlert_getHeight(maxWidth: CGFloat, attributes: [NSAttributedStringKey: Any]?) -> CGFloat {

        let size = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = (self as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        return rect.size.height
    }
}

let separatorHeight = 1 / UIScreen.main.scale
