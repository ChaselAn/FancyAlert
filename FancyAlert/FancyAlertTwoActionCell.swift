//
//  FancyAlertTwoActionCell.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/21.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class FancyAlertTwoActionCell: UITableViewCell {

    var buttonDidClicked: (() -> Void)?

    private var leftButton = UIButton()
    private var rightButton = UIButton()
    private var centerSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = FancyAlertConfig.alertSeparatorColor
        return view
    }()
    private var topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = FancyAlertConfig.alertSeparatorColor
        return view
    }()

    private var actions: [FancyAlertAction] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(leftButton)
        contentView.addSubview(rightButton)
        contentView.addSubview(centerSeparatorView)
        contentView.addSubview(topSeparatorView)

        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        leftButton.trailingAnchor.constraint(equalTo: centerSeparatorView.leadingAnchor).isActive = true
        leftButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        leftButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        leftButton.widthAnchor.constraint(equalTo: rightButton.widthAnchor).isActive = true

        centerSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        centerSeparatorView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        centerSeparatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        centerSeparatorView.widthAnchor.constraint(equalToConstant: FancyAlertConfig.separatorHeight).isActive = true

        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        rightButton.leadingAnchor.constraint(equalTo: centerSeparatorView.trailingAnchor).isActive = true
        rightButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        rightButton.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        topSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        topSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        topSeparatorView.heightAnchor.constraint(equalToConstant: FancyAlertConfig.separatorHeight).isActive = true

        leftButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        leftButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(buttonTouchOutside), for: .touchUpOutside)
        rightButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        rightButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(buttonTouchOutside), for: .touchUpOutside)

        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(actions: [FancyAlertAction], markedColor: UIColor) {
        var tempActions = actions
        guard actions.count == 2 else {
            assertionFailure()
            return
        }
        if tempActions.last!.style == .cancel && tempActions.first!.style != .cancel {
            tempActions.swapAt(0, 1)
        }
        self.actions = tempActions
        leftButton.setTitle(tempActions.first!.title, for: .normal)
        switch tempActions.first!.style {
        case .normal:
            leftButton.setTitleColor(FancyAlertConfig.alertNormalActionDefaultColor, for: .normal)
        case .marked:
            leftButton.setTitleColor(markedColor, for: .normal)
        case .disabled:
            leftButton.setTitleColor(FancyAlertConfig.alertDisabledActionDefaultColor, for: .normal)
        case .cancel:
            leftButton.setTitleColor(FancyAlertConfig.alertCancelActionDefaultColor, for: .normal)
        }
        if let color = tempActions.first!.color {
            leftButton.setTitleColor(color, for: .normal)
        }
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: actions.first!.style == .cancel ? .medium : .semibold)
        leftButton.titleLabel?.minimumScaleFactor = 0.1
        leftButton.titleLabel?.adjustsFontSizeToFitWidth = true

        rightButton.setTitle(tempActions.last!.title, for: .normal)
        switch tempActions.last!.style {
        case .normal:
            rightButton.setTitleColor(FancyAlertConfig.alertNormalActionDefaultColor, for: .normal)
        case .marked:
            rightButton.setTitleColor(markedColor, for: .normal)
        case .disabled:
            rightButton.setTitleColor(FancyAlertConfig.alertDisabledActionDefaultColor, for: .normal)
        case .cancel:
            rightButton.setTitleColor(FancyAlertConfig.alertCancelActionDefaultColor, for: .normal)
        }
        if let color = tempActions.last!.color {
            rightButton.setTitleColor(color, for: .normal)
        }
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: actions.last!.style == .cancel ? .medium : .semibold)
        rightButton.titleLabel?.minimumScaleFactor = 0.1
        rightButton.titleLabel?.adjustsFontSizeToFitWidth = true

        leftButton.alpha = tempActions.first!.isEnabled ? 1 : 0.4
        leftButton.isEnabled = tempActions.first!.isEnabled

        rightButton.alpha = tempActions.last!.isEnabled ? 1 : 0.4
        rightButton.isEnabled = tempActions.last!.isEnabled

        let firstAction = tempActions.first!
        firstAction.enabledDidChange = { [weak self, weak firstAction] isEnabled in
            guard let firstAction = firstAction else { return }
            self?.leftButton.alpha = firstAction.isEnabled ? 1 : 0.4
            self?.leftButton.isEnabled = firstAction.isEnabled
        }

        let lastAction = tempActions.last!
        lastAction.enabledDidChange = { [weak self, weak lastAction] isEnabled in
            guard let lastAction = lastAction else { return }
            self?.rightButton.alpha = lastAction.isEnabled ? 1 : 0.4
            self?.rightButton.isEnabled = lastAction.isEnabled
        }

    }

    @objc private func buttonTouchDown(sender: UIButton) {
        sender.backgroundColor = FancyAlertConfig.alertCellSelectedColor
    }

    @objc private func buttonTouchOutside(sender: UIButton) {
        sender.backgroundColor = UIColor.white
    }

    @objc private func buttonClicked(sender: UIButton) {
        sender.backgroundColor = UIColor.white

        buttonDidClicked?()
        if sender == leftButton {
            actions.first?.handler?()
        } else if sender == rightButton {
            actions.last?.handler?()
        }
    }

}
