//
//  FancyAlertContentEdgeInsets.swift
//  FancyAlert
//
//  Created by ancheng on 2018/12/5.
//  Copyright © 2018 ancheng. All rights reserved.
//

import Foundation

public struct FancyAlertContentEdgeInsets {

    public var left: CGFloat

    public var right: CGFloat

    public init(left: CGFloat, right: CGFloat) {
        self.left = left
        self.right = right
    }
}

extension FancyAlertContentEdgeInsets: Equatable {

    public static func == (lhs: FancyAlertContentEdgeInsets, rhs: FancyAlertContentEdgeInsets) -> Bool {
        return lhs.left == rhs.left && lhs.right == rhs.right
    }
}
