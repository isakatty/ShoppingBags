//
//  RecentSearchedView.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

final class RecentSearchedView: BaseView {
    private let recentLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.bold15
        label.textColor = Constant.Colors.black
        label.text = "최근 검색"
        return label
    }()
    let eraseBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(
            "전체 삭제",
            for: .normal
        )
        btn.setTitleColor(
            Constant.Colors.orange,
            for: .normal
        )
        btn.titleLabel?.font = Constant.Font.regular14
        return btn
    }()
    private let recentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureRecentView()
    }
    
    private func configureHierarchy() {
        [recentView]
            .forEach { addSubview($0) }
        [recentLabel, eraseBtn]
            .forEach { recentView.addSubview($0) }
    }
    private func configureLayout() {
        recentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func configureRecentView() {
        recentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.trailing.lessThanOrEqualTo(eraseBtn.snp.leading)
        }
        eraseBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
