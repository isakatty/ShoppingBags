//
//  SearchViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

public final class SearchViewController: UIViewController {
    private var isRecentSearched: Bool = false
    private var searchedResult: [String] = []
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "브랜드, 상품 등을 입력하세요."
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.delegate = self
        return search
    }()
    private let emptyView = SearchResultEmptyView()
    private let searchedView = RecentSearchedView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureBtns()
    }
    private func configureHierarchy() {
        if isRecentSearched {
            [searchedView]
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
                make.edges.equalTo(safeArea)
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
        UserDefaultsManager.shared.removeValue(forKey: .searchedText)
        isRecentSearched = false
        searchedView.removeFromSuperview()
        emptyView.removeFromSuperview()
        configureHierarchy()
        configureLayout()
    }
    private func fetchData() {
        searchedResult = UserDefaultsManager.shared
            .getValue(forKey: .searchedText) ?? []
        print(#function, searchedResult)
        if !searchedResult.isEmpty {
            isRecentSearched = true
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else { return }
        let searchText = text.trimmingCharacters(in: .whitespaces)
        if !searchText.isEmpty {
            // UserDefaults에 검색어 저장, VC 이동, text 전달해주기
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
