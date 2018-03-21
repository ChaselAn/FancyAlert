//
//  FancyAlertTwoActionCell.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/21.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class FancyAlertTwoActionCell: UITableViewCell {

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
        centerSeparatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true

        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        rightButton.leadingAnchor.constraint(equalTo: centerSeparatorView.trailingAnchor).isActive = true
        rightButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        rightButton.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        topSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        topSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        topSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        leftButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        leftButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        rightButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

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

        leftButton.setTitle(tempActions.first!.title, for: .normal)
        leftButton.setTitleColor(markedColor, for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: actions.first!.style == .cancel ? .medium : .semibold)

        rightButton.setTitle(tempActions.last!.title, for: .normal)
        rightButton.setTitleColor(markedColor, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: actions.last!.style == .cancel ? .medium : .semibold)

    }

    @objc private func buttonTouchDown(sender: UIButton) {
        sender.backgroundColor = UIColor.fancyActionSheetSelectedColor
    }

    @objc private func buttonClicked(sender: UIButton) {
        sender.backgroundColor = UIColor.white
    }

}
