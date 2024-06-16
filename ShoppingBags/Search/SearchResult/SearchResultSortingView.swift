//
//  SearchResultSortingView.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/16/24.
//

import UIKit

public final class SearchResultSortingView: UIView {
    public lazy var accuracyBtn = SortingButton(
        titleForButton: SortedItem.accuracy,
        tag: 0
    )
    public lazy var latestBtn = SortingButton(
        titleForButton: SortedItem.latestDate,
        tag: 1
    )
    public lazy var highestBtn = SortingButton(
        titleForButton: SortedItem.highestPrice,
        tag: 2
    )
    public lazy var lowestBtn = SortingButton(
        titleForButton: SortedItem.highestPrice,
        tag: 3
    )
    
    public override init(frame: CGRect) {
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
