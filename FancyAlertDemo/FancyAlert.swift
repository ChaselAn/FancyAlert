//
//  FancyAlert.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/20.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

public class FancyAlert {

    private static let shared = FancyAlert()

    public static func present(type: UIAlertControllerStyle, title: String?, message: String? = nil, actions: [FancyAlertAction], maskDidClicked: (() -> Void)? = nil, completion: (() -> Void)? = nil) {

        let alertViewController = FancyAlertViewController(type: type, title: title, message: message, actions: actions)
        alertViewController.modalPresentationStyle = .custom
        alertViewController.modalPresentationCapturesStatusBarAppearance = true
        alertViewController.maskDidClicked = maskDidClicked
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: completion)
        }

    }

    public static func dismiss(completion: (() -> Void)? = nil) {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: completion)
    }
}
