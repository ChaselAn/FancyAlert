//
//  FancyAlertCell.swift
//  FancyAlertDemo
//
//  Created by ancheng on 2018/3/21.
//  Copyright © 2018年 ancheng. All rights reserved.
//

import UIKit

class FancyAlertCell: UITableViewCell {

    private let titleLabel = UILabel()
    private var topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = FancyAlertConfig.alertSeparatorColor
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = FancyAlertConfig.alertCellSelectedColor

        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        topSeparatorView.backgroundColor = FancyAlertConfig.alertSeparatorColor
    }

    func setData(action: FancyAlertAction, markedColor: UIColor) {
        titleLabel.text = action.title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: action.style == .cancel ? .medium : .semibold)
        switch action.style {
        case .normal:
            titleLabel.textColor = FancyAlertConfig.alertNormalActionDefaultColor
        case .marked:
            titleLabel.textColor = markedColor
        case .disabled:
            titleLabel.textColor = FancyAlertConfig.alertDisabledActionDefaultColor
        case .cancel:
            titleLabel.textColor = FancyAlertConfig.alertCancelActionDefaultColor
        }
        if let color = action.color {
            titleLabel.textColor = color
        }

        titleLabel.alpha = action.isEnabled ? 1 : 0.4
        isUserInteractionEnabled = action.isEnabled

        let tempAction = action
        tempAction.enabledDidChange = { [weak self, weak action] isEnabled in
            guard let action = action else { return }
            self?.titleLabel.alpha = action.isEnabled ? 1 : 0.4
            self?.isUserInteractionEnabled = action.isEnabled
        }
    }

    private func makeUI() {

        titleLabel.textAlignment = .center
        titleLabel.minimumScaleFactor = 0.1
        titleLabel.adjustsFontSizeToFitWidth = true

        contentView.addSubview(titleLabel)
        contentView.addSubview(topSeparatorView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        topSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        topSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        topSeparatorView.heightAnchor.constraint(equalToConstant: FancyAlertConfig.separatorHeight).isActive = true
    }
}
