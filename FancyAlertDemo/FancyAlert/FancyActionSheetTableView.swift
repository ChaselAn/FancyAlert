//
//  FancyActionSheetTableView.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/21.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

protocol FancyAlertTableViewSource: class {
    var tableViewHeight: CGFloat { get }
    var markedColor: UIColor { set get }
    var margin: CGFloat { get }
}
class FancyActionSheetTableView: UITableView, FancyAlertTableViewSource {

    var tableViewHeight: CGFloat {
        return CGFloat(actions.count) * actionSheetCellHeight + (haveCancelAction ? separatorSectionHeaderHeight : 0) + cornerRadius + (headerView?.headerHeight ?? 0)
    }

    let cornerRadius: CGFloat = 10
    let margin: CGFloat = 13
    var markedColor = UIColor.fancyAlertMarkedDefaultColor
    private let actionSheetCellHeight: CGFloat = 50
    private let separatorSectionHeaderHeight:CGFloat = 11

    private var actions: [FancyAlertAction]
    private var headerView: FancyActionSheetHeaderView?

    private var haveCancelAction: Bool = false

    init(title: String?, message: String?, actions: [FancyAlertAction], width: CGFloat) {
        self.actions = actions
        super.init(frame: CGRect.zero, style: .plain)
        backgroundColor = .white
        isScrollEnabled = false
        dataSource = self
        delegate = self
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        register(FancyActionSheetCell.self, forCellReuseIdentifier: "FancyActionSheetCell")
        separatorStyle = .none
        estimatedRowHeight = actionSheetCellHeight
        contentInset = UIEdgeInsets(top: cornerRadius, left: 0, bottom: 0, right: 0)
        if title != nil || message != nil {
            headerView = FancyActionSheetHeaderView(title: title, message: message, width: width, margin: margin)
            headerView!.frame.size.height = headerView!.headerHeight
            tableHeaderView = headerView
        }

        if let index = self.actions.index(where: { $0.style == .cancel }) {
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
        cell.setData(title: action.title, style: action.style, markedColor: markedColor)
        return cell
    }
}

extension FancyActionSheetTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return actionSheetCellHeight
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
        containerView.backgroundColor = .white
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.fancyAlertSeparatorColor

        containerView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        return haveCancelAction ? containerView : nil
    }
}
