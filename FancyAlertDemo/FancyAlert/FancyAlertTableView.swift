//
//  FancyAlertTableView.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/21.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class FancyAlertTableView: UITableView, FancyAlertTableViewSource {

    var title: String? {
        didSet {
            headerView?.title = title
        }
    }
    var message: String? {
        didSet {
            headerView?.message = message
        }
    }

    var actions: [FancyAlertAction] {
        didSet {
            reloadData()
            bounds.size.height = tableViewHeight
        }
    }

    var hasProgress: Bool = false {
        didSet {
            updateHeaderView()
            (headerView as? FancyAlertProgressHeaderView)?.progress = hasProgress ? progress : nil
        }
    }

    var tableViewHeight: CGFloat {
        return (actions.count == 2 ? alertCellHeight : CGFloat(actions.count) * alertCellHeight) + (headerView?.headerHeight ?? 0)
    }

    let cornerRadius: CGFloat = 10
    let margin: CGFloat = 39
    var markedColor = UIColor.fancyAlertMarkedDefaultColor {
        didSet {
            (headerView as? FancyAlertTextFieldHeaderView)?.markedColor = markedColor
            (headerView as? FancyAlertTextViewHeaderView)?.markedColor = markedColor
        }
    }
    var actionCompleted: (() -> Void)?

    private let alertCellHeight: CGFloat = 50

    private(set) lazy var baseHeaderView: FancyAlertBaseHeaderView? = {
        if title != nil || message != nil {
            let headerView = FancyAlertBaseHeaderView(title: title, message: message, width: alertWidth, margin: margin)
            headerView.frame.size.height = headerView.headerHeight
            headerView.heightChanged = { [weak self, weak headerView] in
                guard let strongSelf = self, let headerView = headerView else { return }
                headerView.frame.size.height = headerView.headerHeight
                strongSelf.bounds.size.height = strongSelf.tableViewHeight
                strongSelf.reloadData()
            }
            return headerView
        }
        return nil
    }()

    private(set) lazy var progressHeaderView: FancyAlertProgressHeaderView? = {
        if title != nil || message != nil {
            let headerView = FancyAlertProgressHeaderView(title: title, message: message, width: alertWidth, margin: margin, progress: progress)
            headerView.frame.size.height = headerView.headerHeight
            headerView.heightChanged = { [weak self, weak headerView] in
                guard let strongSelf = self, let headerView = headerView else { return }
                headerView.frame.size.height = headerView.headerHeight
                strongSelf.bounds.size.height = strongSelf.tableViewHeight
                strongSelf.reloadData()
            }
            return headerView
        }
        return nil
    }()

    private(set) lazy var textFieldHeaderView: FancyAlertTextFieldHeaderView? = {
        guard title != nil || message != nil else {
            return nil
        }
        guard !textFields.isEmpty else {
            fatalError()
        }
        let headerView = FancyAlertTextFieldHeaderView(title: title, message: message, width: alertWidth, margin: margin, textFields: textFields)
        headerView.frame.size.height = headerView.headerHeight
        headerView.heightChanged = { [weak self, weak headerView] in
            guard let strongSelf = self, let headerView = headerView else { return }
            headerView.frame.size.height = headerView.headerHeight
            strongSelf.bounds.size.height = strongSelf.tableViewHeight
            strongSelf.reloadData()
        }
        return headerView
    }()

    private(set) lazy var textViewHeaderView: FancyAlertTextViewHeaderView? = {
        guard title != nil || message != nil else {
            return nil
        }
        guard let textView = textView else {
            fatalError()
        }
        let headerView = FancyAlertTextViewHeaderView(title: title, message: message, width: alertWidth, margin: margin, textView: textView)
        headerView.frame.size.height = headerView.headerHeight
        headerView.heightChanged = { [weak self, weak headerView] in
            guard let strongSelf = self, let headerView = headerView else { return }
            headerView.frame.size.height = headerView.headerHeight
            strongSelf.bounds.size.height = strongSelf.tableViewHeight
            strongSelf.reloadData()
        }
        return headerView
    }()

    private var headerView: FancyAlertBaseHeaderView? {
        if hasProgress {
            return progressHeaderView
        } else if !textFields.isEmpty {
            return textFieldHeaderView
        }else if textView != nil {
            return textViewHeaderView
        } else {
            return baseHeaderView
        }
    }

    private let progress: Float?
    private let alertWidth: CGFloat
    private let textView: FancyTextView?
    private let textFields: [FancyTextField]


    private var workItem: DispatchWorkItem?

    init(title: String?, message: String?, actions: [FancyAlertAction], width: CGFloat, textView: FancyTextView?, textFields: [FancyTextField], progress: Float?) {
        self.actions = actions
        self.progress = progress
        self.alertWidth = width
        self.title = title
        self.message = message
        self.textView = textView
        self.textFields = textFields
        self.hasProgress = progress != nil
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

            tableHeaderView = headerView

            if !textFields.isEmpty || textView != nil {
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: .UIKeyboardWillChangeFrame, object: nil)
            }
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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setProgress(_ progress: Float) {
        (headerView as? FancyAlertProgressHeaderView)?.setProgress(progress)
    }

    private func updateHeaderView() {
        tableHeaderView = headerView
        reloadData()
    }

    @objc private func keyboardWillChangeFrame(notification: Notification) {
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let keyboardY = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.origin.y else { return }
        let offsetY = UIScreen.main.bounds.height - keyboardY
        
        if offsetY > 0 {
            workItem?.cancel()
            workItem = DispatchWorkItem(block: {
                UIView.animate(withDuration: duration, animations: { [weak self] in
                    guard let strongSelf = self else { return }
                    let ty = strongSelf.center.y - keyboardY / 2
                    strongSelf.transform = CGAffineTransform(translationX: 0, y: -ty)
                })
            })
            DispatchQueue.main.async(execute: workItem!)
        } else {
            workItem?.cancel()
            workItem = DispatchWorkItem(block: {
                UIView.animate(withDuration: duration, animations: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.transform = CGAffineTransform.identity
                })
            })
            DispatchQueue.main.async(execute: workItem!)
        }
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
            cell.buttonDidClicked = actionCompleted
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FancyAlertCell", for: indexPath) as! FancyAlertCell
            let action = actions[indexPath.row]
            cell.setData(action: action, markedColor: markedColor)
            return cell
        }
    }
}

extension FancyAlertTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if actions.count == 2 { return }
        actionCompleted?()
        actions[indexPath.row].handler?()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return alertCellHeight
    }
}
