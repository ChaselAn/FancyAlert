//
//  FancyActionSheetTableView.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/21.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

protocol FancyAlertTableViewSource: class {
    var title: String? { set get }
    var message: String? { set get }
    var actions: [FancyAlertAction] { set get }
    var tableViewHeight: CGFloat { get }
    var markedColor: UIColor { set get }
    var actionCompleted: (() -> Void)? { set get }
}
class FancyActionSheetTableView: UITableView, FancyAlertTableViewSource {

    var title: String? // 暂时没用到，留着备用
    var message: String? // 暂时没用到，留着备用

    var tableViewHeight: CGFloat {
        return CGFloat(actions.count) * FancyAlertConfig.actionCellHeight + (haveCancelAction ? separatorSectionHeaderHeight : 0) + FancyAlertConfig.cornerRadius + (headerView?.headerHeight ?? 0)
    }

    var markedColor = FancyAlertConfig.actionSheetMarkedActionDefaultColor

    var actionCompleted: (() -> Void)?

    private let separatorSectionHeaderHeight:CGFloat = 8 + FancyAlertConfig.separatorHeight

    var actions: [FancyAlertAction]
    private var headerView: FancyActionSheetHeaderView?

    private var haveCancelAction: Bool = false

    init(title: String?, message: String?, actions: [FancyAlertAction], width: CGFloat, inset: UIEdgeInsets) {
        self.actions = actions
        super.init(frame: CGRect.zero, style: .plain)
        isScrollEnabled = false
        dataSource = self
        delegate = self
        layer.cornerRadius = FancyAlertConfig.cornerRadius
        layer.masksToBounds = true
        register(FancyActionSheetCell.self, forCellReuseIdentifier: "FancyActionSheetCell")
        separatorStyle = .none
        estimatedRowHeight = FancyAlertConfig.actionCellHeight
        contentInset = UIEdgeInsets(top: FancyAlertConfig.cornerRadius, left: 0, bottom: 0, right: 0)
        if title != nil || message != nil {
            headerView = FancyActionSheetHeaderView(title: title, message: message, width: width, inset: inset)
            headerView!.frame.size.height = headerView!.headerHeight
            tableHeaderView = headerView
        }

        if let index = self.actions.firstIndex(where: { $0.style == .cancel }) {
            haveCancelAction = true
            let cancelAction = actions[index]
            self.actions.remove(at: index)
            self.actions.append(cancelAction)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension FancyActionSheetTableView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return haveCancelAction ? 2 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return haveCancelAction ? actions.count - 1 : actions.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FancyActionSheetCell", for: indexPath) as! FancyActionSheetCell
        let action = indexPath.section == 0 ? actions[indexPath.row] : actions.last!
        cell.backgroundColor = tableView.backgroundColor
        cell.setData(action: action, markedColor: markedColor)
        return cell
    }
}

extension FancyActionSheetTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        actionCompleted?()
        if indexPath.section == 0 {
            let action = actions[indexPath.row]
            action.handler?()
            if action.style == .disabled { return }
        } else {
            actions.last?.handler?()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FancyAlertConfig.actionCellHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        return haveCancelAction ? separatorSectionHeaderHeight : CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != 0 { return nil }
        let containerView = UIView()
        containerView.backgroundColor = tableView.backgroundColor
        let separatorView = UIView()
        separatorView.backgroundColor = FancyAlertConfig.alertSeparatorColor

        containerView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: FancyAlertConfig.separatorHeight).isActive = true

        return haveCancelAction ? containerView : nil
    }
}
