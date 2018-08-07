//
//  AlertTableViewController.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/8/7.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class AlertTableViewController: UITableViewController {

    lazy var firstAction = FancyAlertAction(title: "第一个", style: .normal, handler: {
        print("第一个action")
    })
    lazy var secondAction = FancyAlertAction(title: "第二个", style: .normal, handler: { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.firstAction.isEnabled = !strongSelf.firstAction.isEnabled
        print("第二个action")
    })
    let markedAction = FancyAlertAction(title: "标记", style: .marked, handler: {
        print("标记action")
    })
    let disabledAction = FancyAlertAction(title: "不可用", style: .disabled, handler: {
        print("不可用action")
    })
    let cancelAction = FancyAlertAction(title: "取消", style: .cancel, handler: {
        //            firstAction.isEnabled = !firstAction.isEnabled
        print("取消action")
    })

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let actions1 = [firstAction, cancelAction]

        let actions2 = [cancelAction, firstAction, secondAction]

        let actions3 = [firstAction]
        
        enum RowValue: Int {
            case titleAndMessage
            case title
            case message
            case textField
            case textView
            case progress
        }

        let rowValue = RowValue(rawValue: indexPath.row)!
        switch rowValue {
        case .titleAndMessage:
            let alertVC = FancyAlertViewController(style: .alert, title: "大标题大标题大标题", message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions1)
            present(alertVC, animated: true, completion: nil)
        case .title:
            let alertVC = FancyAlertViewController(style: .alert, title: "大标题大标题大标题大标", message: nil, actions: actions2)
            alertVC.markedColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            present(alertVC, animated: true, completion: nil)
        case .message:
            let alertVC = FancyAlertViewController(style: .alert, title: nil, message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions2)
            present(alertVC, animated: true, completion: nil)
        case .textField:
            let alertVC = FancyAlertViewController(style: .alert, title: nil, message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions1)
            alertVC.editType = .textField
            alertVC.textField.maxInputLength = 10
            present(alertVC, animated: true, completion: nil)
        case .textView:
            let alertVC = FancyAlertViewController(style: .alert, title: "大标题大标题", message: nil, actions: actions1)
            alertVC.editType = .textView
            alertVC.textView.maxInputLength = 50
            present(alertVC, animated: true, completion: nil)
        case .progress:
            let alertVC = FancyAlertViewController(style: .alert, title: "发送中", message: "3张图片", actions: actions3)
            alertVC.hasProgress = true
            alertVC.progress = 0.5
            present(alertVC, animated: true, completion: {
                if #available(iOS 10.0, *) {
                    let timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (_) in
                        if alertVC.progress < 1 {
                            alertVC.progress += 0.1
                        } else {
                            alertVC.progress = 0
                            alertVC.title = "已发送"
                            alertVC.message = "..........."
                            alertVC.hasProgress = false
                            alertVC.actions = actions3
                        }
                    })
                    timer.fire()
                }
            })
        }
    }
}
