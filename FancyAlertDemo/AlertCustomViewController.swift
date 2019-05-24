//
//  AlertCustomViewController.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2019/5/24.
//  Copyright © 2019 ancheng. All rights reserved.
//

import UIKit
import FancyAlert

class AlertCustomViewController: UITableViewController {

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
            case frameView
            case autolayoutView
        }

        let rowValue = RowValue(rawValue: indexPath.row)!
        switch rowValue {
        case .frameView:
            let view = TestFrameView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            let alertController = FancyAlertViewController(style: .alertCustom(containerView: view, viewHeight: 200), title: nil, message: nil, actions: [firstAction, secondAction])
            alertController.markedColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            present(alertController, animated: true, completion: nil)
        case .autolayoutView:
            let view = TestAutoLayoutView()
            let alertController = FancyAlertViewController(style: .alertCustom(containerView: view, viewHeight: 200), title: nil, message: nil, actions: actions)
            present(alertController, animated: true, completion: nil)
        }
    }

}

class TestFrameView: UIView {

    private let redView = UIView()
    private let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(redView)
        addSubview(textLabel)

        redView.frame = CGRect(x: 0, y: 30, width: 50, height: 50)

        textLabel.frame = CGRect(x: 0, y: 100, width: 400, height: 30)

        textLabel.numberOfLines = 0
        textLabel.text = "这是一个很长的文字，这是一个很长的文字，这是一个很长的文字，这是一个很长的文字，这是一个很长的文字，这是一个很长的文字"

        redView.backgroundColor = .red

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class TestAutoLayoutView: UIView {

    private let redView = UIView()
    private let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(redView)
        addSubview(textLabel)

        redView.translatesAutoresizingMaskIntoConstraints = false
        redView.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        redView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        redView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        redView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 100).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true

        redView.backgroundColor = .red

        textLabel.numberOfLines = 0
        textLabel.text = "这是一个很长的文字，这是一个很长的文字，这是一个很长的文字，这是一个很长的文字，这是一个很长的文字，这是一个很长的文字"

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
