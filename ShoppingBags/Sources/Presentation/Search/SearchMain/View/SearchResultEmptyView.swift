//
//  SearchResultEmptyView.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/14/24.
//

import UIKit

final class SearchResultEmptyView: BaseView {
    private lazy var emptyImageView: UIImageView = {
        let view = UIImageView()
        view.image = Constant.Images.empty
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어가 없습니다."
        label.textColor = Constant.Colors.black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        [emptyImageView, emptyLabel]
            .forEach { addSubview($0) }
    }
    private func configureLayout() {
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(emptyImageView.snp.width)
        }
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(10)
            make.centerX.equalTo(emptyImageView)
            make.leading.trailing.equalToSuperview().inset(50)
            
        }
    }
    
}
