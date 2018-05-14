//
//  FancyAlertViewController.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/20.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

public class FancyAlertViewController: UIViewController {

    // 遮罩被点击后的事件
    public var maskDidClicked: (() -> Void)?

    // 被标记的颜色，修改此属性，会影响alert的选项颜色 以及actionsheet中marked、cancel类型的选项
    public var markedColor = UIColor.fancyAlertMarkedDefaultColor

    // 是否有输入框，只适用于alert
    public var isEditable = false

    // 只适用于alert， 可以通过textField.fancy_maxInputLength属性限制输入的最大字数
    public let textField = UITextField()

    // 是否有进度条，只适用于alert
    public var hasProgress = false {
        didSet {
            (tableView as? FancyAlertTableView)?.hasProgress = hasProgress
        }
    }

    // 进度条的进度，只适用于alert
    public var progress: Float = 0 {
        didSet {
            (tableView as? FancyAlertTableView)?.setProgress(progress)
        }
    }

    // title
    public override var title: String? {
        didSet {
            (tableView as? FancyAlertTableViewSource)?.title = title
        }
    }

    // message
    public var message: String? {
        didSet {
            (tableView as? FancyAlertTableViewSource)?.message = message
        }
    }

    // actions
    public var actions: [FancyAlertAction] {
        didSet {
            (tableView as? FancyAlertTableViewSource)?.actions = actions
        }
    }
    public var statusBarStyle: UIStatusBarStyle = .default

    private let maskAlpha: CGFloat = 0.75

    private(set) var tableView: UITableView!
    private(set) var maskControl = UIControl()
    private let alertTransitionManager: FancyAlertTransitionManager
    private let type: UIAlertControllerStyle

    var safeAreaInsetsBottom: CGFloat = 0

    public init(style: UIAlertControllerStyle, title: String?, message: String? = nil, actions: [FancyAlertAction] = []) {
        self.type = style
        self.actions = actions
        self.message = message
        alertTransitionManager = FancyAlertTransitionManager(type: type)
        super.init(nibName: nil, bundle: nil)
        
        self.title = title
        transitioningDelegate = alertTransitionManager

        modalPresentationStyle = .custom
        modalPresentationCapturesStatusBarAppearance = true
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func addAction(_ action: FancyAlertAction) {
        actions.append(action)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
    }

    public override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
            safeAreaInsetsBottom = view.safeAreaInsets.bottom
        }
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
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
            tableView = FancyActionSheetTableView(title: title, message: message, actions: actions, width: view.bounds.width)
        case .alert:
            let alertTableView = FancyAlertTableView(title: title, message: message, actions: actions, width: view.bounds.width, isEditable: isEditable, textField: textField, progress: hasProgress ? progress : nil)
            tableView = alertTableView
        }
        (tableView as! FancyAlertTableViewSource).markedColor = markedColor
        (tableView as! FancyAlertTableViewSource).actionCompleted = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        view.addSubview(tableView)

    }

    @objc private func maskControlDidClicked() {
        self.dismiss(animated: true, completion: nil)
        maskDidClicked?()
    }
}
