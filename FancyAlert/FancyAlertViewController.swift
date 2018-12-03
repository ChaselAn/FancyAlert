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

    // dismiss完成后的回调
    public var dismissCompleted: (() -> Void)?

    // 被标记的颜色，修改此属性，会影响alert的选项颜色 以及actionsheet中marked、cancel类型的选项
    public var markedColor = UIColor.fancyAlertMarkedDefaultColor

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

    // 只适用于alert
    public private(set) var textFields: [FancyTextField] = []

    // 只适用于alert
    public private(set) var textView: FancyTextView?

    public var statusBarStyle: UIStatusBarStyle = .default

    public var maskStyle: MaskStyle = .default

    public enum MaskStyle {
        case `default`    // 可见可点
        case disabled     // 可见不可点
        case transparent(enable: Bool)   // 透明的
        case custom(enable: Bool, color: UIColor, alpha: CGFloat)
    }

    private let maskAlpha: CGFloat = 0.75

    private(set) var tableView: UITableView!
    private(set) var maskControl = UIControl()
    private let alertTransitionManager: FancyAlertTransitionManager
    private let type: UIAlertController.Style

    var safeAreaInsetsBottom: CGFloat = 0

    public init(style: UIAlertController.Style, title: String?, message: String? = nil, actions: [FancyAlertAction] = []) {
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

    public func addTextField(_ completionHandler: ((FancyTextField) -> ())?) {
        guard type == .alert else {
            fatalError("Text fields can only be added to an alert controller of style UIAlertControllerStyleAlert")
        }
        let textField = FancyTextField()
        textFields.append(textField)
        completionHandler?(textField)
    }

    public func addTextView(_ completionHandler: ((FancyTextView) -> ())?) {
        guard type == .alert else {
            fatalError("Text view can only be added to an alert controller of style UIAlertControllerStyleAlert")
        }
        let textView = FancyTextView()
        self.textView = textView
        completionHandler?(textView)
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

        switch maskStyle {
        case .default, .disabled:
            maskControl.backgroundColor = UIColor.black.withAlphaComponent(maskAlpha)
        case .transparent:
            maskControl.backgroundColor = UIColor.black.withAlphaComponent(0)
        case .custom(_, let color, let alpha):
            maskControl.backgroundColor = color.withAlphaComponent(alpha)
        }
        maskControl.addTarget(self, action: #selector(maskControlDidClicked), for: .touchUpInside)
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
            let alertTableView = FancyAlertTableView(title: title, message: message, actions: actions, width: view.bounds.width, textView: textView, textFields: textFields, progress: hasProgress ? progress : nil)
            tableView = alertTableView
        }
        (tableView as! FancyAlertTableViewSource).markedColor = markedColor
        (tableView as! FancyAlertTableViewSource).actionCompleted = { [weak self] in
            self?.dismiss(animated: true, completion: { [weak self] in
                self?.dismissCompleted?()
            })
        }
        view.addSubview(tableView)

    }

    @objc private func maskControlDidClicked() {
        let maskEnable: Bool
        switch maskStyle {
        case .default:
            maskEnable = true
        case .disabled:
            maskEnable = false
        case .transparent(let enable):
            maskEnable = enable
        case .custom(let enable, _, _):
            maskEnable = enable
        }

        if maskEnable {
            self.dismiss(animated: true, completion: nil)
        }
        maskDidClicked?()
    }
}
