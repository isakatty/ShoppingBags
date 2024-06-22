//
//  CircledProfileView.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/17/24.
//

import UIKit

public final class CircledProfileView: UIView {
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
    
    public init(hasClearBtn: Bool) {
        super.init(frame: .zero)
        
        configureHierarchy(with: hasClearBtn)
        configureLayout(with: hasClearBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy(with clearBtn: Bool) {
        [profileImg]
            .forEach { addSubview($0) }
        if clearBtn {
            addSubview(clearButton)
        }
    }
    private func configureLayout(with clearBtn: Bool) {
        profileImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if clearBtn {
            clearButton.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
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
