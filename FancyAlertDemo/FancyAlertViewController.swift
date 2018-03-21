//
//  FancyAlertViewController.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/20.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class FancyAlertViewController: UIViewController {
    
    var maskDidClicked: (() -> Void)?
    var markedColor = UIColor.fancyAlertMarkedDefaultColor

    var tableViewHeight: CGFloat {
        return CGFloat(actions.count) * actionSheetCellHeight + (haveCancelAction ? 11 : 0) + cornerRadius + (headerView?.headerHeight ?? 0)
    }

    let cornerRadius: CGFloat = 10
    let margin: CGFloat = 13
    private let maskAlpha: CGFloat = 0.75
    private let actionSheetCellHeight: CGFloat = 50

    private var actions: [FancyAlertAction]
    private var haveCancelAction: Bool = false

    private(set) var tableView = UITableView()
    private(set) var tableViewBottomConstraint: NSLayoutConstraint?
    private var tableViewHeightConstraint: NSLayoutConstraint?

    private var maskControl = UIControl()
    private let alertTransitionManager: FancyAlertTransitionManager
    private let type: UIAlertControllerStyle
    private let fancyTitle: String?
    private let message: String?
    private var headerView: FancyActionSheetHeaderView?

    init(type: UIAlertControllerStyle, title: String?, message: String? = nil, actions: [FancyAlertAction]) {
        self.type = type
        self.actions = actions
        self.fancyTitle = title
        self.message = message
        alertTransitionManager = FancyAlertTransitionManager(type: type)
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = alertTransitionManager
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        if let index = actions.index(where: { $0.style == .cancel }) {
            haveCancelAction = true
            let cancelAction = actions[index]
            actions.remove(at: index)
            actions.append(cancelAction)
        }
    }

    private func makeUI() {

        maskControl.addTarget(self, action: #selector(maskControlDidClicked), for: .touchUpInside)
        maskControl.backgroundColor = UIColor.black.withAlphaComponent(maskAlpha)
        view.addSubview(maskControl)
        maskControl.translatesAutoresizingMaskIntoConstraints = false
        maskControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        maskControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        maskControl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        maskControl.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = cornerRadius
        tableView.layer.masksToBounds = true
        tableView.register(FancyActionSheetCell.self, forCellReuseIdentifier: "FancyActionSheetCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = actionSheetCellHeight
        tableView.contentInset = UIEdgeInsets(top: cornerRadius, left: 0, bottom: 0, right: 0)
        if fancyTitle != nil || message != nil {
            headerView = FancyActionSheetHeaderView(title: fancyTitle, message: message, width: view.bounds.width, margin: margin)
            headerView!.frame.size.height = headerView!.headerHeight
            tableView.tableHeaderView = headerView
        }

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

    }

    @objc private func maskControlDidClicked() {
        maskDidClicked?()
    }
}

extension FancyAlertViewController: UITableViewDataSource {

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

extension FancyAlertViewController: UITableViewDelegate {

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
        return haveCancelAction ? 11 : CGFloat.leastNonzeroMagnitude
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
