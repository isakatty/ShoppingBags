//
//  CircledProfileView.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/17/24.
//

import UIKit

final class CircledProfileView: BaseView {
    var profileImg = UIImageView()
    var clearButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(
            "",
            for: .normal
        )
        btn.tintColor = .clear
        return btn
    }()
    
    init(hasClearBtn: Bool) {
        super.init(frame: .zero)
        
        configureHierarchy(with: hasClearBtn)
        configureLayout(with: hasClearBtn)
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
        clipsToBounds = true
        layer.borderWidth = isSelected ? 3 : 1
        layer.borderColor = isSelected
        ? Constant.Colors.orange?.cgColor
        : Constant.Colors.lightGray?.cgColor
        layer.opacity = isSelected ? 1 : 0.5
    }
    func configureUI(
        img: UIImage?,
        isSelected: Bool
    ) {
        profileImg.image = img?.withRenderingMode(.alwaysOriginal)
        profileImg.contentMode = .scaleAspectFit
        profileImg.clipsToBounds = true
        configureView(isSelected: isSelected)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
    }
}
