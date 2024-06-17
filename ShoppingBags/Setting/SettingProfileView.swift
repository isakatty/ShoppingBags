//
//  SettingProfileView.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/17/24.
//

import UIKit

public final class SettingProfileView: UIView {
    public let clearBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        return btn
    }()
    
    private let profileImg = CircledProfileView(
        img: UIImage(named: "profile_0"),
        isSelected: true
    )
    private let profileName: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.bold17
        label.textColor = Constant.Colors.darkGray
        label.text = "옹골찬 고래밥"
        return label
    }()
    private let profileDate: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.regular13
        label.textColor = Constant.Colors.lightGray
        label.text = "2024.06.15 가입" // 데이트 포매터 필요하겠음.
        return label
    }()
    private let rightChevronImg: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.image = Constant.SystemImages.rightChevron
        image.tintColor = Constant.Colors.darkGray
        return image
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [profileImg, profileName, profileDate, rightChevronImg, clearBtn]
            .forEach { addSubview($0) }
    }
    private func configureLayout() {
        backgroundColor = .systemBackground
        
        profileImg.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(profileImg.snp.height)
        }
        profileName.snp.makeConstraints { make in
            make.leading.equalTo(profileImg.snp.trailing).inset(-20)
            make.bottom.equalTo(self.snp.centerY)
            make.trailing.lessThanOrEqualTo(rightChevronImg.snp.leading)
        }
        profileDate.snp.makeConstraints { make in
            make.top.equalTo(profileName.snp.bottom).offset(4)
            make.leading.equalTo(profileImg.snp.trailing).inset(-20)
            make.trailing.lessThanOrEqualTo(rightChevronImg.snp.leading)
        }
        rightChevronImg.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(16)
            make.width.equalTo(rightChevronImg.snp.height).multipliedBy(0.6)
            make.centerY.equalToSuperview()
        }
        clearBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
}