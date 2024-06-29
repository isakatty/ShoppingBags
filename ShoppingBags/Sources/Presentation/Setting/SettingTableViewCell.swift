//
//  SettingTableViewCell.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/16/24.
//

import UIKit

final class SettingTableViewCell: BaseTableViewCell {
    private let settingLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constant.Colors.black
        label.font = Constant.Font.regular14
        return label
    }()
    private let shoppingLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.regular15
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
    
    override init(
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
    func configureUI(index: Int) {
        if index == 0 {
            shoppingView.isHidden = false
            settingLabel.text = Setting.allCases[index].rawValue
            shoppingLabel.text = Setting.allCases[index].shoppingItem
            let targetString = shoppingLabel.text?
                .components(separatedBy: "의").first
            shoppingLabel.highlightedText(
                targetString: targetString ?? "",
                font: Constant.Font.bold15
            )
        } else {
            shoppingView.isHidden = true
            settingLabel.text = Setting.allCases[index].rawValue
        }
    }
}
