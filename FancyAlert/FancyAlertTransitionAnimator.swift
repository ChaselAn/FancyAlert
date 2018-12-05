//
//  FancyAlertTransitionAnimator.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/20.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class FancyAlertTransitionAnimator: NSObject {
    var isDismissing: Bool = false

    private let type: UIAlertController.Style

    init(type: UIAlertController.Style) {
        self.type = type
        super.init()
    }
}

extension FancyAlertTransitionAnimator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        switch type {
        case .alert:
            return 0.15
        case .actionSheet:
            return 0.25
        }
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let key: UITransitionContextViewControllerKey = isDismissing ? .from : .to
        let controller = transitionContext.viewController(forKey: key)!
        if !isDismissing {
            transitionContext.containerView.addSubview(controller.view)
        }
        let initialAlpha: CGFloat = isDismissing ? 1 : 0
        let finalAlpha: CGFloat = isDismissing ? 0 : 1

        let animationDuration = transitionDuration(using: transitionContext)

        guard let alertController = controller as? FancyAlertViewController else { return }
        let tableViewHeight = (alertController.tableView as! FancyAlertTableViewSource).tableViewHeight
        switch type {
        case .alert:
            alertController.view.alpha = initialAlpha
            if !isDismissing {
                alertController.tableView.center = alertController.view.center
                alertController.tableView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            alertController.tableView.bounds.size = CGSize(width: alertController.view.bounds.width - alertController.alertContentInset.left - alertController.alertContentInset.right, height: tableViewHeight)
            UIView.animate(withDuration: animationDuration, animations: {
                alertController.view.alpha = finalAlpha
                alertController.tableView.transform = CGAffineTransform.identity
            }, completion: { [weak self] finished in
                transitionContext.completeTransition(finished)
                let textField = alertController.textFields.first
                let textView = alertController.textView
                guard let strongSelf = self else { return }
                if strongSelf.isDismissing {
                    textField?.resignFirstResponder()
                    textView?.resignFirstResponder()
                } else {
                    textField?.becomeFirstResponder()
                    textView?.becomeFirstResponder()
                }
            })
        case .actionSheet:
            alertController.maskControl.alpha = initialAlpha
            var behavior: FancyAlertViewController.PrivateContentInsetAdjustmentBehavior = .never
            if #available(iOS 11.0, *) {
                if let privateBehavior = alertController._actionSheetContentInsetAdjustmentBehavior {
                    behavior = privateBehavior
                } else {
                    switch FancyAlertConfig.actionSheetContentInsetAdjustmentBehavior {
                    case .always:
                        behavior = .always
                    case .never:
                        behavior = .never
                    case .alwaysAndTileDown:
                        behavior = .alwaysAndTileDown
                    }
                }
            }
            let insetsBottom: CGFloat
            let newTableViewHeight: CGFloat
            switch behavior {
            case .always:
                insetsBottom = alertController.safeAreaInsetsBottom + alertController.actionSheetContentInset.bottom
                newTableViewHeight = tableViewHeight
            case .never:
                insetsBottom = alertController.actionSheetContentInset.bottom
                newTableViewHeight = tableViewHeight
            case .alwaysAndTileDown:
                insetsBottom = alertController.actionSheetContentInset.bottom
                newTableViewHeight = tableViewHeight + alertController.safeAreaInsetsBottom
            }
            let beginY = !isDismissing ? alertController.view.bounds.height : alertController.view.bounds.height - newTableViewHeight - insetsBottom
            let endY = isDismissing ? alertController.view.bounds.height : alertController.view.bounds.height - newTableViewHeight - insetsBottom
            alertController.tableView.frame = CGRect(x: alertController.actionSheetContentInset.left, y: beginY, width: alertController.view.bounds.width - alertController.actionSheetContentInset.left - alertController.actionSheetContentInset.right, height: newTableViewHeight)
            UIView.animate(withDuration: animationDuration, animations: { 
                alertController.maskControl.alpha = finalAlpha
                alertController.tableView.frame.origin.y = endY
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        }

    }

}
