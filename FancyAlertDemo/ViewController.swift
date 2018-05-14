//
//  ViewController.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/20.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var actions: [FancyAlertAction] = []
    var actions1: [FancyAlertAction] = []
    var actions2: [FancyAlertAction] = []
    var actions3: [FancyAlertAction] = []

    let button = UIButton(type: .system)
    let button1 = UIButton(type: .system)
    let button2 = UIButton(type: .system)
    let button3 = UIButton(type: .system)
    let button4 = UIButton(type: .system)

    let rightButton = UIButton(type: .system)
    let rightButton1 = UIButton(type: .system)
    let rightButton2 = UIButton(type: .system)
    let rightButton3 = UIButton(type: .system)
    let rightButton4 = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        button.setTitle("show alert", for: .normal)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        button.frame = CGRect(x: 50, y: 100, width: 100, height: 50)
        view.addSubview(button)

        button1.setTitle("show alert", for: .normal)
        button1.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        button1.frame = CGRect(x: 50, y: 200, width: 100, height: 50)
        view.addSubview(button1)

        button2.setTitle("show alert", for: .normal)
        button2.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        button2.frame = CGRect(x: 50, y: 300, width: 100, height: 50)
        view.addSubview(button2)

        button3.setTitle("show alert", for: .normal)
        button3.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        button3.frame = CGRect(x: 50, y: 400, width: 100, height: 50)
        view.addSubview(button3)

        button4.setTitle("show alert", for: .normal)
        button4.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        button4.frame = CGRect(x: 50, y: 500, width: 100, height: 50)
        view.addSubview(button4)

        rightButton.setTitle("show actionSheet", for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonButtonClicked), for: .touchUpInside)
        rightButton.frame = CGRect(x: 200, y: 100, width: 150, height: 50)
        view.addSubview(rightButton)


        rightButton1.setTitle("show actionSheet", for: .normal)
        rightButton1.addTarget(self, action: #selector(rightButtonButtonClicked), for: .touchUpInside)
        rightButton1.frame = CGRect(x: 200, y: 200, width: 150, height: 50)
        view.addSubview(rightButton1)

        rightButton2.setTitle("show actionSheet", for: .normal)
        rightButton2.addTarget(self, action: #selector(rightButtonButtonClicked), for: .touchUpInside)
        rightButton2.frame = CGRect(x: 200, y: 300, width: 150, height: 50)
        view.addSubview(rightButton2)

        rightButton3.setTitle("show actionSheet", for: .normal)
        rightButton3.addTarget(self, action: #selector(rightButtonButtonClicked), for: .touchUpInside)
        rightButton3.frame = CGRect(x: 200, y: 400, width: 150, height: 50)
        view.addSubview(rightButton3)

        rightButton4.setTitle("show actionSheet", for: .normal)
        rightButton4.addTarget(self, action: #selector(rightButtonButtonClicked), for: .touchUpInside)
        rightButton4.frame = CGRect(x: 200, y: 500, width: 150, height: 50)
        view.addSubview(rightButton4)

        let firstAction = FancyAlertAction(title: "第一个", style: .normal, handler: {
            print("第一个action")
        })
//        firstAction.isEnabled = false
        let secondAction = FancyAlertAction(title: "第二个", style: .normal, handler: {
            firstAction.isEnabled = !firstAction.isEnabled
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

        actions = [cancelAction, firstAction, secondAction, markedAction, disabledAction]

        actions1 = [firstAction, cancelAction]

        actions2 = [cancelAction, firstAction, secondAction]

        actions3 = [firstAction]
    }
    

    @objc private func buttonClicked(sender: UIButton) {
//        FancyAlert.present(type: .alert, title: "大标题大标题大标题大标题大标题大标题大标题大标题大标题", message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions, maskDidClicked: {
//            FancyAlert.dismiss()
//        })

        if sender == button {
            let alertVC = FancyAlertViewController(style: .alert, title: "大标题大标题大标题大标题大标题大标题大标题大标题大标题", message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions2)
            alertVC.textField.placeholder = "请输入文字"
            alertVC.markedColor = UIColor.green
            alertVC.isEditable = true
            alertVC.textField.fancy_maxInputLength = 5
            present(alertVC, animated: true, completion: nil)
        } else if sender == button1 {

            let alertVC = FancyAlertViewController(style: .alert, title: "大标题大标题大标题", message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions2)
            present(alertVC, animated: true, completion: nil)

        } else if sender == button2 {

            let alertVC = FancyAlertViewController(style: .alert, title: "大标题大标题大标题大标", message: nil, actions: actions2)
//            alertVC.isEditable = true
            present(alertVC, animated: true, completion: nil)

        } else if sender == button3 {

//            let alertVC = FancyAlertViewController(type: .alert, title: nil, message: "小标题小标题小标题小", actions: actions1)
//            present(alertVC, animated: true, completion: nil)
            let alertVC = FancyAlertViewController(style: .alert, title: nil, message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions1)
            alertVC.isEditable = true
            alertVC.textField.fancy_maxInputLength = 10
            alertVC.markedColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            present(alertVC, animated: true, completion: nil)

        } else if sender == button4 {

            let alertVC = FancyAlertViewController(style: .alert, title: "发送中", message: "3张图片", actions: actions3)
//            alertVC.isEditable = true
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
                            alertVC.message = "asdfljklasdf"
                            alertVC.hasProgress = false
                            alertVC.actions = self.actions3
                        }
                    })
                    timer.fire()
                }
            })

        }
    }

    @objc private func rightButtonButtonClicked(sender: UIButton) {

        if sender == rightButton {
//            FancyAlert.present(type: .actionSheet, title: "大标题大标题", message: "小标题小标题", actions: actions, maskDidClicked: {
//                FancyAlert.dismiss()
//            })
            let alertVC = FancyAlertViewController(style: .actionSheet, title: "大标题大标题", message: "小标题小标题", actions: actions)
            alertVC.markedColor = UIColor.green
            present(alertVC, animated: true, completion: nil)
        } else if sender == rightButton1 {
            let alertController = FancyAlertViewController(style: .actionSheet, title: "大标题大标题大标题大标题大标题大题大标题大标题大标题大标题大标题大标标题大标题大标题大标题大标题大标题大标题大标题", message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions)
            present(alertController, animated: true, completion: nil)
        } else if sender == rightButton2 {
            let alertController = FancyAlertViewController(style: .actionSheet, title: "大标题大标题大标题大标题大标题标题大标题大标题大标题大标题大标题大标题大标题大标题", message: nil, actions: actions)
            present(alertController, animated: true, completion: nil)
        } else if sender == rightButton3 {
            let alertController = FancyAlertViewController(style: .actionSheet, title: nil, message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions)
            present(alertController, animated: true, completion: nil)
        } else if sender == rightButton4 {
            let alertController = FancyAlertViewController(style: .actionSheet, title: nil, message: nil, actions: actions)
            present(alertController, animated: true, completion: nil)
        }

//        let actionSheet = UIAlertController(title: "大标题", message: "小标题圣诞快乐福建阿凉快圣诞节法律手段减肥啦圣诞节了肯定就是分开了", preferredStyle: .actionSheet)
//        let action = UIAlertAction.init(title: "是吗", style: .default, handler: nil)
//        action.isEnabled = false
//        actionSheet.addAction(action)
//        actionSheet.addAction(UIAlertAction.init(title: "取消收款方结果绿色空间都发给老师叫对方立刻感觉山东路放假桂林市地方见过凉快圣诞节发过来跨境电商发过来跨境电商立丰国际", style: .cancel, handler: nil))
//        present(actionSheet, animated: true, completion: nil)
    }

}

