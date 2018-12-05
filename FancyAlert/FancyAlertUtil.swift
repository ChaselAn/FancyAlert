//
//  FancyAlertUtil.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/22.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

extension String {

    func fancyAlert_getHeight(maxWidth: CGFloat, attributes: [NSAttributedString.Key: Any]?) -> CGFloat {

        let size = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = (self as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        return rect.size.height
    }
}
