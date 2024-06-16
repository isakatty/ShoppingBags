//
//  SearchedItemCollectionViewCell.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/16/24.
//

import UIKit

import Kingfisher

public final class SearchedItemCollectionViewCell: UICollectionViewCell {
    private let itemImgView: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        img.layer.cornerRadius
         = Constant.CornerRadius.collectionViewImg.rawValue
        return img
    }()
    private lazy var mallNameLabel = makeLabel(
        font: Constant.Font.light13,
        color: Constant.Colors.lightGray,
        lines: 1
    )
    private lazy var itemNameLabel = makeLabel(
        font: Constant.Font.regular14,
        color: Constant.Colors.black,
        lines: 2
    )
    private lazy var itemPriceLabel = makeLabel(
        font: Constant.Font.bold15,
        color: Constant.Colors.black,
        lines: 1
    )
    public lazy var shoppingBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = Constant.Images.likeUnselected
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 10,
            bottom: 5,
            trailing: 10
        )
        let imgConfig = UIImage.SymbolConfiguration(
            font: Constant.Font.regular13
        )
        let btn = UIButton(configuration: config)
        btn.backgroundColor = Constant.Colors.lightGray
        btn.layer.cornerRadius
        = Constant.CornerRadius.shoppingBagBg.rawValue
        return btn
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [
            itemImgView,
            shoppingBtn,
            mallNameLabel,
            itemNameLabel,
            itemPriceLabel
        ]
            .forEach { contentView.addSubview($0) }
    }
    private func configureLayout() {
        itemImgView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(itemImgView.snp.width).multipliedBy(1.2)
        }
        shoppingBtn.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(itemImgView).inset(10)
            make.width.height.equalTo(itemImgView.snp.width).multipliedBy(0.2)
        }
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImgView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(15)
        }
        itemNameLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        itemPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(17)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    private func makeLabel(
        font: UIFont,
        color: UIColor?,
        lines: Int
    ) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        label.numberOfLines = lines
        return label
    }
    public func configureUI(item: Item, tag: Int) {
        shoppingBtn.tag = tag
        fetchFavItems(itemID: item.productId)
        mallNameLabel.text = item.mallName
        itemNameLabel.text = item.formattedItemName
        itemPriceLabel.text = item.formattedPrice
        
        guard let url = URL(string: item.itemImage) else { return }
        itemImgView.kf.setImage(with: url)
    }
    
    private func fetchFavItems(itemID: String) {
        var favItems: [String] = UserDefaultsManager.shared
            .getValue(forKey: .shoppingBags) ?? []
        configureBtnUI(isContained: favItems.contains(itemID))
    }
    /// Btn UI
    public func configureBtnUI(isContained: Bool) {
        var config = UIButton.Configuration.plain()
        config.image = isContained
        ? Constant.Images.likeSelected
        : Constant.Images.likeUnselected
        shoppingBtn.configuration = config
        shoppingBtn.backgroundColor = isContained
        ? Constant.Colors.white
        : Constant.Colors.lightGray
        shoppingBtn.layer.opacity = isContained ? 1.0 : 0.5
    }
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        itemImgView.image = nil
        [
            mallNameLabel,
            itemNameLabel,
            itemPriceLabel
        ]
            .forEach { $0.text = nil }
    }
}
