//
//  RecentSearchedView.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

public final class RecentSearchedView: UIView {
    private let recentLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.bold15
        label.textColor = Constant.Colors.black
        label.text = "최근 검색"
        return label
    }()
    public let eraseBtn: UIButton = {
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
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureRecentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
//    private func fetchData(searchedData: [String]) -> [String] {
//        UserDefaultsManager.shared.saveValue(
//            searchedData,
//            forKey: SaveData.searchedText
//        )
//        let returnData: [String] = UserDefaultsManager.shared.getValue(
//            forKey: SaveData.searchedText
//        ) ?? []
//        print(returnData)
//        return returnData
//    }
}
