//
//  RecentSearchedView.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

public final class RecentSearchedView: UIView {
    // 데이터 받을 공간
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(
            RecentSearchTableViewCell.self,
            forCellReuseIdentifier: RecentSearchTableViewCell.identifier
        )
        table.rowHeight = 40
        table.separatorStyle = .none
        return table
    }()
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
        [tableView, recentView]
            .forEach { addSubview($0) }
        [recentLabel, eraseBtn]
            .forEach { recentView.addSubview($0) }
    }
    private func configureLayout() {
        recentView.snp.makeConstraints { make in
            make.top.leading.trailing.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(recentView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
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

extension RecentSearchedView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        // 검색 결과 데이터.count
        return 1
    }
    
    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecentSearchTableViewCell.identifier,
            for: indexPath
        ) as? RecentSearchTableViewCell else { return UITableViewCell() }
        
        cell.configureUI(recentSearched: "대략적인 UI 작업")
        return cell
    }
}
