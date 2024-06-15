//
//  SearchViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

public final class SearchViewController: UIViewController {
    private var isRecentSearched: Bool = true
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "브랜드, 상품 등을 입력하세요."
        search.hidesNavigationBarDuringPresentation = false
        return search
    }()
    private let emptyView = SearchResultEmptyView()
    private let searchedView = RecentSearchedView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
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
    
}
