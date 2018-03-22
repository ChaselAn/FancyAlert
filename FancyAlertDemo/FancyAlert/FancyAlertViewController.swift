//
//  FancyAlertViewController.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/20.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

public class FancyAlertViewController: UIViewController {
    
    public var maskDidClicked: (() -> Void)?
    public var markedColor = UIColor.fancyAlertMarkedDefaultColor {
        didSet {
            (tableView as! FancyAlertTableViewSource).markedColor = markedColor
        }
    }
    public var isEditable = false
    public let textField = UITextField()
    
    private let maskAlpha: CGFloat = 0.75

    private(set) var tableView: UITableView!

    private var maskControl = UIControl()
    private let alertTransitionManager: FancyAlertTransitionManager
    private let type: UIAlertControllerStyle
    private let fancyTitle: String?
    private let message: String?
    private var actions: [FancyAlertAction]

    public init(type: UIAlertControllerStyle, title: String?, message: String? = nil, actions: [FancyAlertAction]) {
        self.type = type
        self.actions = actions
        self.fancyTitle = title
        self.message = message
        alertTransitionManager = FancyAlertTransitionManager(type: type)
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = alertTransitionManager

        modalPresentationStyle = .custom
        modalPresentationCapturesStatusBarAppearance = true
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
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
            let alertTableView = FancyAlertTableView(title: fancyTitle, message: message, actions: actions, width: view.bounds.width, isEditable: isEditable, textField: textField)
            tableView = alertTableView
        }
        view.addSubview(tableView)

    }

    @objc private func maskControlDidClicked() {
        maskDidClicked?()
    }
}
