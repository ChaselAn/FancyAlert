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

        let firstAction = FancyAlertAction(title: "第一个", style: .normal, action: {
            print("第一个action")
        })
        let secondAction = FancyAlertAction(title: "第二个", style: .normal, action: {
            print("第二个action")
        })
        let markedAction = FancyAlertAction(title: "标记", style: .marked, action: {
            print("标记action")
        })
        let disabledAction = FancyAlertAction(title: "不可用", style: .disabled, action: {
            print("不可用action")
        })
        let cancelAction = FancyAlertAction(title: "取消", style: .cancel, action: {
            print("取消action")
        })
        actions = [cancelAction, firstAction, secondAction, markedAction, disabledAction]

        actions1 = [firstAction, cancelAction]

        actions2 = [cancelAction, firstAction, secondAction]

    }
    

    @objc private func buttonClicked(sender: UIButton) {
//        FancyAlert.present(type: .alert, title: "大标题大标题大标题大标题大标题大标题大标题大标题大标题", message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions, maskDidClicked: {
//            FancyAlert.dismiss()
//        })

        if sender == button {
            let alertVC = FancyAlertViewController(type: .alert, title: "大标题大标题大标题大标题大标题大标题大标题大标题大标题", message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions2)
            alertVC.textField.placeholder = "请输入文字"
            alertVC.markedColor = UIColor.green
            alertVC.isEditable = true
            present(alertVC, animated: true, completion: nil)
        } else if sender == button1 {

            let alertVC = FancyAlertViewController(type: .alert, title: "大标题大标题大标题", message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions2)
            present(alertVC, animated: true, completion: nil)

        } else if sender == button2 {

            let alertVC = FancyAlertViewController(type: .alert, title: "大标题大标题大标题大标", message: nil, actions: actions2)
            alertVC.isEditable = true
            present(alertVC, animated: true, completion: nil)

        } else if sender == button3 {

            let alertVC = FancyAlertViewController(type: .alert, title: nil, message: "小标题小标题小标题小", actions: actions1)
            present(alertVC, animated: true, completion: nil)

        } else if sender == button4 {

            let alertVC = FancyAlertViewController(type: .alert, title: "大标题大标题大标题大标题", message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions1)
            alertVC.isEditable = true
            present(alertVC, animated: true, completion: nil)

        }
    }

    @objc private func rightButtonButtonClicked(sender: UIButton) {

        if sender == rightButton {
//            FancyAlert.present(type: .actionSheet, title: "大标题大标题", message: "小标题小标题", actions: actions, maskDidClicked: {
//                FancyAlert.dismiss()
//            })
            let alertVC = FancyAlertViewController(type: .actionSheet, title: "大标题大标题", message: "小标题小标题", actions: actions)
            alertVC.markedColor = UIColor.green
            present(alertVC, animated: true, completion: nil)
        } else if sender == rightButton1 {
            FancyAlert.present(type: .actionSheet, title: "大标题大标题大标题大标题大标题大题大标题大标题大标题大标题大标题大标标题大标题大标题大标题大标题大标题大标题大标题", message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions)
        } else if sender == rightButton2 {
            FancyAlert.present(type: .actionSheet, title: "大标题大标题大标题大标题大标题标题大标题大标题大标题大标题大标题大标题大标题大标题", message: nil, actions: actions)
        } else if sender == rightButton3 {
            FancyAlert.present(type: .actionSheet, title: nil, message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: actions)
        } else if sender == rightButton4 {
            FancyAlert.present(type: .actionSheet, title: nil, message: nil, actions: actions)
        }

//        let actionSheet = UIAlertController(title: "大标题", message: "小标题圣诞快乐福建阿凉快圣诞节法律手段减肥啦圣诞节了肯定就是分开了", preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction.init(title: "是吗", style: .default, handler: nil))
//        actionSheet.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
//        present(actionSheet, animated: true, completion: nil)
    }

}

