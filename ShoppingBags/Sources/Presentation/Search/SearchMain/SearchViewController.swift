//
//  SearchViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

final class SearchViewController: BaseViewController {
    private var isRecentSearched: Bool = false
    private var searchedResult: [String] = [] {
        didSet {
            searchedTableView.reloadData()
        }
    }
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "브랜드, 상품 등을 입력하세요."
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.delegate = self
        return search
    }()
    private let emptyView = SearchResultEmptyView()
    private let searchedView = RecentSearchedView()
    private lazy var searchedTableView: UITableView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        configureNaviTitle(title: ViewTitle.main.mainTitle)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        configureBtns()
        configureHierarchy()
        configureLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
        configureNaviTitle(title: ViewTitle.main.mainTitle)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    private func configureHierarchy() {
        [searchedView, searchedTableView, emptyView]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        searchedView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeArea)
            make.height.equalTo(40)
        }
        searchedTableView.snp.makeConstraints { make in
            make.top.equalTo(searchedView.snp.bottom)
            make.leading.trailing.bottom.equalTo(safeArea)
        }
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
    private func configureBtns() {
        searchedView.eraseBtn.addTarget(
            self,
            action: #selector(eraseBtnTapped),
            for: .touchUpInside
        )
    }
    private func fetchData() {
        searchedResult = UserDefaultsManager.shared
            .getValue(forKey: .searchedText) ?? []
        print(searchedResult, #function)
        isRecentSearched = !searchedResult.isEmpty ? true : false
        if isRecentSearched {
            emptyView.isHidden = true
            [searchedView, searchedTableView]
                .forEach { $0.isHidden = false }
        } else {
            emptyView.isHidden = false
            [searchedView, searchedTableView]
                .forEach { $0.isHidden = true }
        }
    }
    @objc private func eraseBtnTapped() {
        searchedResult.removeAll()
        UserDefaultsManager.shared.saveValue(
            searchedResult,
            forKey: .searchedText
        )
        print(#function)
        fetchData()
    }
    @objc private func deleteBtnTapped(sender: UIButton) {
        searchedResult.remove(at: sender.tag)
        UserDefaultsManager.shared.saveValue(
            searchedResult,
            forKey: .searchedText
        )
        print("=======")
        fetchData()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard var text = searchBar.text?.trimmingCharacters(in: .whitespaces),
              !text.isEmpty else { return }
        text = text.split(separator: " ").joined()
        findWords(search: text)
        searchBar.text = nil
        let resultVC = SearchResultViewController()
        resultVC.searchedText = text
        navigationController?.pushViewController(
            resultVC,
            animated: true
        )
    }
    private func findWords(search: String) {
        searchedResult.removeAll { $0 == search}
        searchedResult.insert(
            search,
            at: 0
        )
        UserDefaultsManager.shared.saveValue(
            searchedResult,
            forKey: .searchedText
        )
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return searchedResult.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecentSearchTableViewCell.identifier,
            for: indexPath
        ) as? RecentSearchTableViewCell
        else { return UITableViewCell() }
        cell.configureUI(
            recentSearched: searchedResult[indexPath.row],
            tag: indexPath.row
        )
        cell.xmarkBtn.addTarget(
            self,
            action: #selector(deleteBtnTapped),
            for: .touchUpInside
        )
        return cell
    }
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        searchedTableView.reloadData()
        
        let vc = SearchResultViewController()
        vc.searchedText = searchedResult[indexPath.row]
        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
}
