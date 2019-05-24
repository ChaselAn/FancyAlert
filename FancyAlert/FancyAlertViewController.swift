//
//  FancyAlertViewController.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/20.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

open class FancyAlertViewController: UIViewController {

    // 遮罩被点击后的事件
    open var maskDidClicked: (() -> Void)?

    // dismiss完成后的回调
    open var dismissCompleted: (() -> Void)?

    // 被标记的颜色，修改此属性，会影响alert的选项颜色 以及actionsheet中marked的选项
    open var markedColor = FancyAlertConfig.actionSheetMarkedActionDefaultColor

    open var backgroundColor = FancyAlertConfig.backgroundColor

    open var actionSheetContentInset = FancyAlertConfig.actionSheetContentInset

    open var alertContentInset = FancyAlertConfig.alertContentInset

    @available(iOS 11.0, *)
    open var actionSheetContentInsetAdjustmentBehavior: ContentInsetAdjustmentBehavior {
        get {
            return _actionSheetContentInsetAdjustmentBehavior?.ios11Value ?? FancyAlertConfig.actionSheetContentInsetAdjustmentBehavior
        }
        set {
            switch newValue {
            case .always:
                _actionSheetContentInsetAdjustmentBehavior = .always
            case .never:
                _actionSheetContentInsetAdjustmentBehavior = .never
            case .alwaysAndTileDown:
                _actionSheetContentInsetAdjustmentBehavior = .alwaysAndTileDown
            }
        }
    }

    // 是否有进度条，只适用于alert
    open var hasProgress = false {
        didSet {
            (tableView as? FancyAlertTableView)?.hasProgress = hasProgress
        }
    }

    // 进度条的进度，只适用于alert
    open var progress: Float = 0 {
        didSet {
            (tableView as? FancyAlertTableView)?.setProgress(progress)
        }
    }

    // title
    open override var title: String? {
        didSet {
            (tableView as? FancyAlertTableViewSource)?.title = title
        }
    }

    // message
    open var message: String? {
        didSet {
            (tableView as? FancyAlertTableViewSource)?.message = message
        }
    }

    // actions
    open var actions: [FancyAlertAction] {
        didSet {
            (tableView as? FancyAlertTableViewSource)?.actions = actions
        }
    }

    // 只适用于alert
    open private(set) var textFields: [FancyTextField] = []

    // 只适用于alert
    open private(set) var textView: FancyTextView?

    open var statusBarStyle: UIStatusBarStyle = .default

    open var maskStyle: MaskStyle = .default

    public enum MaskStyle {
        case `default`    // 可见可点
        case disabled     // 可见不可点
        case transparent(enable: Bool)   // 透明的
        case custom(enable: Bool, color: UIColor, alpha: CGFloat)
    }

    @available(iOS 11.0, *)
    public enum ContentInsetAdjustmentBehavior {
        case always
        case never
        case alwaysAndTileDown
    }

    public enum Style: Equatable {
        case alert
        case actionSheet
        case alertCustom(containerView: UIView, viewHeight: CGFloat)
    }

    private let maskAlpha: CGFloat = 0.75

    private(set) var tableView: UITableView!
    private(set) var maskControl = UIControl()
    private let alertTransitionManager: FancyAlertTransitionManager
    private let type: Style
    private(set) var _actionSheetContentInsetAdjustmentBehavior: PrivateContentInsetAdjustmentBehavior?

    enum PrivateContentInsetAdjustmentBehavior {
        case always
        case never
        case alwaysAndTileDown

        @available(iOS 11.0, *)
        var ios11Value: ContentInsetAdjustmentBehavior {
            switch self {
            case .always:
                return .always
            case .never:
                return .never
            case .alwaysAndTileDown:
                return .alwaysAndTileDown
            }
        }
    }

    var safeAreaInsetsBottom: CGFloat = 0

    public init(style: Style, title: String?, message: String? = nil, actions: [FancyAlertAction] = []) {
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

    open func addAction(_ action: FancyAlertAction) {
        actions.append(action)
    }

    open func addTextField(_ completionHandler: ((FancyTextField) -> ())?) {
        guard type == .alert else {
            fatalError("Text fields can only be added to an alert controller of style UIAlertControllerStyleAlert")
        }
        let textField = FancyTextField()
        textFields.append(textField)
        completionHandler?(textField)
    }

    open func addTextView(_ completionHandler: ((FancyTextView) -> ())?) {
        guard type == .alert else {
            fatalError("Text view can only be added to an alert controller of style UIAlertControllerStyleAlert")
        }
        let textView = FancyTextView()
        self.textView = textView
        completionHandler?(textView)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
    }

    open override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
            safeAreaInsetsBottom = view.safeAreaInsets.bottom
        }
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
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
            tableView = FancyActionSheetTableView(title: title, message: message, actions: actions, width: view.bounds.width, inset: actionSheetContentInset)
        case .alert:
            let alertTableView = FancyAlertTableView(title: title, message: message, actions: actions, width: view.bounds.width, textView: textView, textFields: textFields, progress: hasProgress ? progress : nil, inset: alertContentInset)
            tableView = alertTableView
        case .alertCustom(containerView: let containerView, let height):
            let alertTableView = FancyAlertCustomTableView(customView: containerView, height: height, actions: actions, width: view.bounds.width, inset: alertContentInset)
            tableView = alertTableView
        }
        (tableView as! FancyAlertTableViewSource).markedColor = markedColor
        (tableView as! FancyAlertTableViewSource).actionCompleted = { [weak self] in
            self?.dismiss(animated: true, completion: { [weak self] in
                self?.dismissCompleted?()
            })
        }
        tableView.backgroundColor = backgroundColor
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
