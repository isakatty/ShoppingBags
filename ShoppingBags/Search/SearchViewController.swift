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
    private lazy var searchedView = RecentSearchedView()
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
        configureNavigationBar()
        configureBtns()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        fetchData()
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
    private func configureNavigationBar() {
        navigationItem.title = "옹골찬 고래밥's MEANING OUT"
        navigationItem.searchController 
        = searchController
        navigationController?.navigationBar.tintColor = Constant.Colors.black
    }
    private func configureBtns() {
        searchedView.eraseBtn.addTarget(
            self,
            action: #selector(eraseBtnTapped),
            for: .touchUpInside
        )
    }
    @objc private func eraseBtnTapped() {
        // Alert 띄우기
        let erasedArray: [String] = []
        // MARK: remove가 잘 안되는 이유를 찾을 것.
        UserDefaultsManager.shared.saveValue(
            erasedArray,
            forKey: .searchedText
        )
        fetchData()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    private func fetchData() {
        searchedResult = UserDefaultsManager.shared
            .getValue(forKey: .searchedText) ?? []
        print(#function, searchedResult)
        isRecentSearched = !searchedResult.isEmpty ? true : false
        searchedView.removeFromSuperview()
        emptyView.removeFromSuperview()
        configureHierarchy()
        configureLayout()
    }
    @objc private func deleteBtnTapped(sender: UIButton) {
        var copySearched = searchedResult
        // TODO: 저장할 때 같은 값 저장되는거 지워야함
        for searched in copySearched
        where searchedResult[sender.tag] == searched {
                copySearched.remove(at: sender.tag)
        }
        print(copySearched)
        UserDefaultsManager.shared.saveValue(
            copySearched,
            forKey: .searchedText
        )
        fetchData()
    }
}

extension SearchViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else { return }
        let searchText = text.trimmingCharacters(in: .whitespaces)
        if !searchText.isEmpty {
            // UserDefaults에 검색어 저장, VC 이동, text 전달해주기
            searchBar.text = nil
            searchedResult.insert(text, at: 0)
            UserDefaultsManager.shared.saveValue(
                searchedResult,
                forKey: .searchedText
            )
            let resultVC = SearchResultViewController()
            resultVC.searchedText = text
            navigationController?.pushViewController(
                resultVC,
                animated: true
            )
        }
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
}
