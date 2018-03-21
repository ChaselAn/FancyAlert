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
    var markedColor = UIColor.fancyAlertMarkedDefaultColor
    private let alertCellHeight: CGFloat = 50

    private var actions: [FancyAlertAction]
    private var headerView: FancyAlertHeaderView?

    init(title: String?, message: String?, actions: [FancyAlertAction], width: CGFloat) {
        self.actions = actions
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
            headerView = FancyAlertHeaderView(title: title, message: message, width: width, margin: margin)
            headerView!.frame.size.height = headerView!.headerHeight
            tableHeaderView = headerView
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
    
}

extension FancyAlertTableView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count == 2 ? 1 : actions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if actions.count == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FancyAlertTwoActionCell", for: indexPath) as! FancyAlertTwoActionCell
            cell.setData(actions: actions, markedColor: markedColor)
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

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return alertCellHeight
    }
}
