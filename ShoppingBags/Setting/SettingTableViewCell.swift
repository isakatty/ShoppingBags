//
//  SettingTableViewCell.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/16/24.
//

import UIKit

public final class SettingTableViewCell: UITableViewCell {
    private let settingLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constant.Colors.black
        label.font = Constant.Font.regular15
        return label
    }()
    private let shoppingLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.bold15
        label.textColor = Constant.Colors.black
        return label
    }()
    private let shoppingBagImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.image = Constant.Images.likeSelected?
            .withRenderingMode(.alwaysTemplate)
        img.tintColor = Constant.Colors.black
        return img
    }()
    private let shoppingView = UIView()
    
    public override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        configureHierarchy()
        configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [settingLabel, shoppingView]
            .forEach { contentView.addSubview($0) }
        [shoppingBagImage, shoppingLabel]
            .forEach { shoppingView.addSubview($0) }
    }
    private func configureLayout() {
        backgroundColor = .systemBackground
        settingLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualTo(shoppingView.snp.leading)
        }
        shoppingView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
        }
        shoppingBagImage.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.height.equalTo(shoppingBagImage.snp.width)
        }
        shoppingLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(shoppingBagImage.snp.trailing)
        }
    }
    public func configureUI(index: Int) {
        // Enum으로 받을 것.
        if index == 0 {
            shoppingView.isHidden = false
            settingLabel.text = Setting.allCases[index].rawValue
            shoppingLabel.text = Setting.allCases[index].shoppingItem
        } else {
            shoppingView.isHidden = true
            settingLabel.text = Setting.allCases[index].rawValue
        }
    }
}
