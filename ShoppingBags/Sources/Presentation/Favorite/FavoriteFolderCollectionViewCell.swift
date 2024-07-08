//
//  FavoriteFolderCollectionViewCell.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 7/8/24.
//

import UIKit

final class FavoriteFolderCollectionViewCell: UICollectionViewCell {
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Colors.darkGray
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    private let folderNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.regular15
        label.textColor = Constant.Colors.white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [bgView, folderNameLabel]
            .forEach { contentView.addSubview($0) }
    }
    private func configureLayout() {
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        folderNameLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalTo(bgView)
        }
    }
    func configureUI(folderName: String) {
        folderNameLabel.text = folderName
    }
    
}
