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
    var markedColor = UIColor.fancyAlertMarkedDefaultColor {
        didSet {
            (tableView as! FancyAlertTableViewSource).markedColor = markedColor
        }
    }
    var isEditable = false
    
    private let maskAlpha: CGFloat = 0.75

    private(set) var tableView: UITableView!

    private var maskControl = UIControl()
    private let alertTransitionManager: FancyAlertTransitionManager
    private let type: UIAlertControllerStyle
    private let fancyTitle: String?
    private let message: String?
    private var actions: [FancyAlertAction]

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

        switch type {
        case .actionSheet:
            tableView = FancyActionSheetTableView(title: fancyTitle, message: message, actions: actions, width: view.bounds.width)
        case .alert:
            tableView = FancyAlertTableView(title: fancyTitle, message: message, actions: actions, width: view.bounds.width)
        }
        view.addSubview(tableView)

    }

    @objc private func maskControlDidClicked() {
        maskDidClicked?()
    }
}
