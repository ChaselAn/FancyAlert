//
//  FancyActionSheetCell.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/21.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class FancyActionSheetCell: UITableViewCell {

    private let titleLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor.fancyActionSheetSelectedColor

        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(action: FancyAlertAction, markedColor: UIColor) {
        titleLabel.text = action.title
        switch action.style {
        case .normal:
            titleLabel.textColor = UIColor.fancyAlertNormalDefaultColor
        case .marked:
            titleLabel.textColor = markedColor
        case .disabled:
            titleLabel.textColor = UIColor.fancyAlertDisabledDefaultColor
        case .cancel:
            titleLabel.textColor = markedColor
        }
        titleLabel.alpha = action.isEnabled ? 1 : 0.4
        isUserInteractionEnabled = action.isEnabled

        let tempAction = action
        tempAction.enabledDidChange = { [weak self] isEnabled in
            self?.titleLabel.alpha = action.isEnabled ? 1 : 0.4
            self?.isUserInteractionEnabled = action.isEnabled
        }
    }

    private func makeUI() {

        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

}
