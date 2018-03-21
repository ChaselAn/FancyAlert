//
//  FancyAlertTransitonManager.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/20.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class FancyAlertTransitionManager: NSObject {

    var animator: FancyAlertTransitionAnimator

    init(type: UIAlertControllerStyle) {
        animator = FancyAlertTransitionAnimator(type: type)
        super.init()
    }

}

extension FancyAlertTransitionManager: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isDismissing = false
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isDismissing = true
        return animator
    }
}
