//
//  RecentSearchTableViewCell.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

public final class RecentSearchTableViewCell: UITableViewCell {
    private let timeImg: UIImageView = {
        let img = UIImageView()
        img.image = Constant.SystemImages.clock?
            .withRenderingMode(.alwaysTemplate)
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .clear
        img.clipsToBounds = true
        img.tintColor = Constant.Colors.black
        return img
    }()
    private let searchedLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.bold15
        label.textColor = Constant.Colors.black
        return label
    }()
    private let xmarkBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(
            Constant.SystemImages.xmark,
            for: .normal
        )
        btn.tintColor = Constant.Colors.black
        btn.setTitle("", for: .normal)
        return btn
    }()
    
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
        [timeImg, searchedLabel, xmarkBtn]
            .forEach { contentView.addSubview($0) }
    }
    private func configureLayout() {
        timeImg.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(timeImg.snp.height)
        }
        searchedLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(timeImg.snp.trailing).inset(-10)
            make.trailing.equalTo(xmarkBtn.snp.leading).inset(-10)
            make.center.equalToSuperview()
        }
        
        xmarkBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }
    public func configureUI(recentSearched: String) {
        searchedLabel.text = recentSearched
    }
}
