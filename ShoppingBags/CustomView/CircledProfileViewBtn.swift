//
//  CircledProfileViewBtn.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/17/24.
//

import UIKit

public final class CircledProfileViewBtn: UIView {
    private var profileImg = UIImageView()
    public var clearButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.tintColor = .clear
        return btn
    }()
    
    public init(
        img: UIImage?,
        isSelected: Bool
    ) {
        super.init(frame: .zero)
        
        guard let img else { return }
        
        profileImg = configureImgView(img: img)
        configureHierarchy()
        configureLayout()
        configureView(isSelected: isSelected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImgView(img: UIImage) -> UIImageView {
        let imgView = UIImageView()
        imgView.image = img.withRenderingMode(.alwaysOriginal)
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
    }
}
