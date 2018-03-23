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
        view.backgroundColor = UIColor.fancyAlertSeparatorColor
        return view
    }()
    private var topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fancyAlertSeparatorColor
        return view
    }()

    private var actions: [FancyAlertAction] = []

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
        centerSeparatorView.widthAnchor.constraint(equalToConstant: separatorHeight).isActive = true

        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        rightButton.leadingAnchor.constraint(equalTo: centerSeparatorView.trailingAnchor).isActive = true
        rightButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        rightButton.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        topSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        topSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        topSeparatorView.heightAnchor.constraint(equalToConstant: separatorHeight).isActive = true

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
        leftButton.setTitleColor(markedColor, for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: actions.first!.style == .cancel ? .medium : .semibold)
        leftButton.titleLabel?.minimumScaleFactor = 0.1
        leftButton.titleLabel?.adjustsFontSizeToFitWidth = true

        rightButton.setTitle(tempActions.last!.title, for: .normal)
        rightButton.setTitleColor(markedColor, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: actions.last!.style == .cancel ? .medium : .semibold)
        rightButton.titleLabel?.minimumScaleFactor = 0.1
        rightButton.titleLabel?.adjustsFontSizeToFitWidth = true

        leftButton.alpha = tempActions.first!.isEnabled ? 1 : 0.4
        leftButton.isEnabled = tempActions.first!.isEnabled

        rightButton.alpha = tempActions.last!.isEnabled ? 1 : 0.4
        rightButton.isEnabled = tempActions.last!.isEnabled

        tempActions.first!.enabledDidChange = { [weak self] isEnabled in
            self?.leftButton.alpha = tempActions.first!.isEnabled ? 1 : 0.4
            self?.leftButton.isEnabled = tempActions.first!.isEnabled
        }

        tempActions.last!.enabledDidChange = { [weak self] isEnabled in
            self?.rightButton.alpha = tempActions.last!.isEnabled ? 1 : 0.4
            self?.rightButton.isEnabled = tempActions.last!.isEnabled
        }

    }

    @objc private func buttonTouchDown(sender: UIButton) {
        sender.backgroundColor = UIColor.fancyActionSheetSelectedColor
    }

    @objc private func buttonTouchOutside(sender: UIButton) {
        sender.backgroundColor = UIColor.white
    }

    @objc private func buttonClicked(sender: UIButton) {
        sender.backgroundColor = UIColor.white

        if sender == leftButton {
            actions.first?.handler?()
        } else if sender == rightButton {
            actions.last?.handler?()
        }
        buttonDidClicked?()
    }

}
