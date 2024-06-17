//
//  EditingCollectionViewCell.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/17/24.
//

import UIKit

public final class EditingCollectionViewCell: UICollectionViewCell {
    private lazy var profileImage = CircledProfileView()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureHierarchy() {
        contentView.addSubview(profileImage)
    }
    private func configureLayout() {
        backgroundColor = .systemBackground
        profileImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    public func configureUI(
        img: UIImage?,
        isSelected: Bool
    ) {
        profileImage.configureUI(
            img: img,
            isSelected: isSelected
        )
    }
}
