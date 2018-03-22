//
//  FancyAlertTableView.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/21.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class FancyAlertTableView: UITableView, FancyAlertTableViewSource {

    var tableViewHeight: CGFloat {
        return (actions.count == 2 ? alertCellHeight : CGFloat(actions.count) * alertCellHeight) + (headerView?.headerHeight ?? 0)
    }

    let cornerRadius: CGFloat = 10
    let margin: CGFloat = 39
    var markedColor = UIColor.fancyAlertMarkedDefaultColor {
        didSet {
            headerView?.markedColor = markedColor
        }
    }
    var actionCompleted: (() -> Void)?

    private let alertCellHeight: CGFloat = 50

    private var actions: [FancyAlertAction]
    private(set) var headerView: FancyAlertHeaderView?
    private let textField: UITextField

    private var workItem: DispatchWorkItem?

    init(title: String?, message: String?, actions: [FancyAlertAction], width: CGFloat, isEditable: Bool, textField: UITextField) {
        self.actions = actions
        self.textField = textField
        super.init(frame: CGRect.zero, style: .plain)
        backgroundColor = .white
        isScrollEnabled = false
        dataSource = self
        delegate = self
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        register(FancyAlertTwoActionCell.self, forCellReuseIdentifier: "FancyAlertTwoActionCell")
        register(FancyAlertCell.self, forCellReuseIdentifier: "FancyAlertCell")
        separatorStyle = .none
        if title != nil || message != nil {
            headerView = FancyAlertHeaderView(title: title, message: message, width: width, margin: margin, isEditable: isEditable, textField: textField)
            headerView!.frame.size.height = headerView!.headerHeight
            tableHeaderView = headerView

            if isEditable {
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: .UIKeyboardWillChangeFrame, object: nil)
            }
        }

        if actions.count > 2, let index = self.actions.index(where: { $0.style == .cancel }) {
            let cancelAction = actions[index]
            self.actions.remove(at: index)
            self.actions.append(cancelAction)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillChangeFrame(notification: Notification) {
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let keyboardY = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.origin.y else { return }
        let offsetY = UIScreen.main.bounds.height - keyboardY
        
        if offsetY > 0 {
            workItem?.cancel()
            workItem = DispatchWorkItem(block: {
                UIView.animate(withDuration: duration, animations: { [weak self] in
                    guard let strongSelf = self else { return }
                    let ty = strongSelf.center.y - keyboardY / 2
                    strongSelf.transform = CGAffineTransform(translationX: 0, y: -ty)
                })
            })
            DispatchQueue.main.async(execute: workItem!)
        } else {
            workItem?.cancel()
            workItem = DispatchWorkItem(block: {
                UIView.animate(withDuration: duration, animations: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.transform = CGAffineTransform.identity
                })
            })
            DispatchQueue.main.async(execute: workItem!)
        }
    }
}

extension FancyAlertTableView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count == 2 ? 1 : actions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if actions.count == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FancyAlertTwoActionCell", for: indexPath) as! FancyAlertTwoActionCell
            cell.setData(actions: actions, markedColor: markedColor)
            cell.buttonDidClicked = actionCompleted
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FancyAlertCell", for: indexPath) as! FancyAlertCell
            let action = actions[indexPath.row]
            cell.setData(title: action.title, style: action.style, markedColor: markedColor)
            return cell
        }
    }
}

extension FancyAlertTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if actions.count == 2 { return }
        actions[indexPath.row].handler?()
        actionCompleted?()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return alertCellHeight
    }
}
