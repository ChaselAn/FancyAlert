//
//  FancyCustomTableView.swift
//  FancyAlert
//
//  Created by ancheng on 2019/5/24.
//  Copyright © 2019 ancheng. All rights reserved.
//

import Foundation

class FancyAlertCustomTableView: UITableView, FancyAlertTableViewSource {
    var title: String?

    var message: String?

    var actions: [FancyAlertAction] {
        didSet {
            reloadData()
            bounds.size.height = tableViewHeight
        }
    }

    var tableViewHeight: CGFloat {
        layoutIfNeeded()
        return CGFloat(actions.count) * FancyAlertConfig.actionCellHeight + customView.bounds.height
    }

    var markedColor = FancyAlertConfig.actionSheetMarkedActionDefaultColor

    var actionCompleted: (() -> Void)?

    private let headerView = FancyAlertCustomHeaderView()
    private let customView: UIView
    private let inset: FancyAlertContentEdgeInsets

    init(customView: UIView, height: CGFloat, actions: [FancyAlertAction], width: CGFloat, inset: FancyAlertContentEdgeInsets) {
        self.actions = actions
        self.inset = inset
        self.customView = customView
        super.init(frame: CGRect.zero, style: .plain)
        
        isScrollEnabled = false
        dataSource = self
        delegate = self
        layer.cornerRadius = FancyAlertConfig.cornerRadius
        layer.masksToBounds = true
        register(FancyAlertTwoActionCell.self, forCellReuseIdentifier: "FancyAlertTwoActionCell")
        register(FancyAlertCell.self, forCellReuseIdentifier: "FancyAlertCell")
        separatorStyle = .none

        headerView.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        customView.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true

        headerView.frame.size.height = height

        tableHeaderView = headerView

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension FancyAlertCustomTableView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FancyAlertCell", for: indexPath) as! FancyAlertCell
        let action = actions[indexPath.row]
        cell.setData(action: action, markedColor: markedColor)
        return cell
    }
}

extension FancyAlertCustomTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        actionCompleted?()
        actions[indexPath.row].handler?()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FancyAlertConfig.actionCellHeight
    }
}

class FancyAlertCustomHeaderView: UIView {}
