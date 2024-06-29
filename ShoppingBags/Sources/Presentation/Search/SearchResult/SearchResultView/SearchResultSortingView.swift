//
//  SearchResultSortingView.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/16/24.
//

import UIKit

final class SearchResultSortingView: UIView {
    lazy var accuracyBtn = SortingButton(
        titleForButton: SortedItem.accuracy,
        tag: 0
    )
    lazy var latestBtn = SortingButton(
        titleForButton: SortedItem.latestDate,
        tag: 1
    )
    lazy var highestBtn = SortingButton(
        titleForButton: SortedItem.highestPrice,
        tag: 2
    )
    lazy var lowestBtn = SortingButton(
        titleForButton: SortedItem.lowestPrice,
        tag: 3
    )
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [accuracyBtn, latestBtn, highestBtn, lowestBtn]
            .forEach { addSubview($0) }
    }
    private func configureLayout() {
        accuracyBtn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        latestBtn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalTo(accuracyBtn.snp.trailing).inset(-10)
        }
        highestBtn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalTo(latestBtn.snp.trailing).inset(-10)
        }
        lowestBtn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalTo(highestBtn.snp.trailing).inset(-10)
        }
    }
}
