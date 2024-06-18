//
//  CircledProfileViewBtn.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/17/24.
//

import UIKit

public final class CircledProfileViewBtn: UIView {
    public var profileImg = UIImageView()
    public var clearButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(
            "",
            for: .normal
        )
        btn.tintColor = .clear
        return btn
    }()
    
    public init() {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [profileImg, clearButton]
            .forEach { addSubview($0) }
    }
    private func configureLayout() {
        profileImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        clearButton.snp.makeConstraints { make in
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
    public func configureUI(
        img: UIImage?,
        isSelected: Bool
    ) {
        profileImg.image = img?.withRenderingMode(.alwaysOriginal)
        profileImg.contentMode = .scaleAspectFit
        profileImg.clipsToBounds = true
        configureView(isSelected: isSelected)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
    }
}
