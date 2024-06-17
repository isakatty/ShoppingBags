//
//  SearchViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

public final class SearchViewController: UIViewController {
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        configureNaviTitle(title: ViewTitle.main.mainTitle)
        
        navigationItem.searchController
        = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        configureBtns()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    private func configureHierarchy() {
        if isRecentSearched {
            [searchedView, searchedTableView]
                .forEach { view.addSubview($0) }
        } else {
            [emptyView]
                .forEach { view.addSubview($0) }
        }
    }
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .systemBackground
        if isRecentSearched {
            searchedView.snp.makeConstraints { make in
                make.top.leading.trailing.equalTo(safeArea)
                make.height.equalTo(40)
            }
            searchedTableView.snp.makeConstraints { make in
                make.top.equalTo(searchedView.snp.bottom)
                make.leading.trailing.bottom.equalTo(safeArea)
            }
        } else {
            emptyView.snp.makeConstraints { make in
                make.edges.equalTo(safeArea)
            }
        }
    }
    private func configureBtns() {
        searchedView.eraseBtn.addTarget(
            self,
            action: #selector(eraseBtnTapped),
            for: .touchUpInside
        )
    }
    @objc private func eraseBtnTapped() {
        let erasedArray: [String] = []
        // MARK: remove가 잘 안되는 이유를 찾을 것.
        UserDefaultsManager.shared.saveValue(
            erasedArray,
            forKey: .searchedText
        )
        fetchData()
    }
    private func fetchData() {
        searchedResult = UserDefaultsManager.shared
            .getValue(forKey: .searchedText) ?? []
        isRecentSearched = !searchedResult.isEmpty ? true : false
        searchedView.removeFromSuperview()
        emptyView.removeFromSuperview()
        configureHierarchy()
        configureLayout()
    }
    @objc private func deleteBtnTapped(sender: UIButton) {
        searchedResult.remove(at: sender.tag)
        UserDefaultsManager.shared.saveValue(
            searchedResult,
            forKey: .searchedText
        )
        fetchData()
    }
}

extension SearchViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespaces),
        !text.isEmpty else { return }
        
        if findWords(search: text) {
            searchBar.text = nil
            let resultVC = SearchResultViewController()
            resultVC.searchedText = text
            navigationController?.pushViewController(
                resultVC,
                animated: true
            )
        }
    }
    private func findWords(search: String) -> Bool {
        
        var checkDuplication = Array(Set(searchedResult))
        checkDuplication.removeAll { $0 == search}
        checkDuplication.insert(search, at: 0)
        UserDefaultsManager.shared.saveValue(
            checkDuplication,
            forKey: .searchedText
        )
        return true
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return searchedResult.count
    }
    
    public func tableView(
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
    public func tableView(
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
