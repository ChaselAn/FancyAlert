//
//  ActionSheetTableViewController.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/8/7.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit
import FancyAlert

class ActionSheetTableViewController: UITableViewController {

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
        print("取消action")
    })

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let actions = [cancelAction, firstAction, secondAction, markedAction, disabledAction]

        enum RowValue: Int {
            case titleAndMessage
            case title
            case message
            case noTitleAndMessage
        }

        let rowValue = RowValue(rawValue: indexPath.row)!
        switch rowValue {
        case .titleAndMessage:
            let alertController = FancyAlertViewController(style: .actionSheet, title: "大标题大标题大标题大标题大标题大题大标题大标题大标题大标题大标题大标标题大标题大标题大标题大标题大标题大标题大标题", message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions)
            alertController.markedColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            present(alertController, animated: true, completion: nil)
        case .title:
            let alertController = FancyAlertViewController(style: .actionSheet, title: "大标题大标题大标题大标题大标题标题大标题大标题大标题大标题大标题大标题大标题大标题", message: nil, actions: actions)
            present(alertController, animated: true, completion: nil)
        case .message:
            let alertController = FancyAlertViewController(style: .actionSheet, title: nil, message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions)
            present(alertController, animated: true, completion: nil)
        case .noTitleAndMessage:
            let alertController = FancyAlertViewController(style: .actionSheet, title: nil, message: nil, actions: actions)
            present(alertController, animated: true, completion: nil)
        }
    }

}
