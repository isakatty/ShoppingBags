//
//  CircledProfileView.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/14/24.
//

import UIKit

public final class CircledProfileView: UIView {
    private var profileImg = UIImageView()
    
    public init() {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func configureUI(
        img: UIImage?,
        isSelected: Bool
    ) {
        profileImg.image = img?.withRenderingMode(.alwaysOriginal)
        configureView(isSelected: isSelected)
    }
    private func configureHierarchy() {
        addSubview(profileImg)
    }
    private func configureLayout() {
        profileImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func configureView(isSelected: Bool) {
        backgroundColor = .white
        clipsToBounds = true
        layer.borderWidth = isSelected ? 3 : 1
        layer.borderColor = isSelected 
        ? Constant.Colors.orange?.cgColor
        : Constant.Colors.lightGray?.cgColor
        layer.opacity = isSelected ? 1 : 0.5
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
