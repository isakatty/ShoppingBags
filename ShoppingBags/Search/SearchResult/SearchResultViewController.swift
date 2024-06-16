//
//  SearchResultViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

import Alamofire

public final class SearchResultViewController: UIViewController {
    public var searchedText: String?
    private var isLastPage: Bool = false
    private var page: Int = 1
    private var sorting: SortedItem = .accuracy
    private lazy var searchedResult: Search = Search(
        total: 0,
        start: 0,
        display: 0,
        items: []
    )
    private let totalItemLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.bold15
        label.textColor = Constant.Colors.orange
        // dummy Text
        label.text = "235,499개의 검색결과"
        return label
    }()
    private lazy var itemCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout()
        )
        collection.delegate = self
        collection.dataSource = self
        collection.register(
            SearchedItemCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchedItemCollectionViewCell.identifier
        )
        collection.autoresizingMask = [.flexibleHeight]
        collection.prefetchDataSource = self
        return collection
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let searchedText else { return }
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        callRequest(
            searchText: searchedText,
            startPage: page,
            sorting: sorting
        )
    }
    private func configureHierarchy() {
        [totalItemLabel, itemCollectionView]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        let safeArea = view.safeAreaLayoutGuide
        totalItemLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(safeArea)
            make.leading.equalTo(safeArea).inset(12)
            make.height.equalTo(20)
        }
        itemCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(safeArea)
            make.top.equalTo(totalItemLabel.snp.bottom)
        }
    }
    private func configureNavigationBar() {
        navigationItem.title = searchedText
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Constant.SystemImages.leftChevron,
            style: .plain,
            target: self,
            action: #selector(customBackBtnTapped)
        )
        navigationController?
            .interactivePopGestureRecognizer?.delegate = nil
        navigationController?.navigationBar.tintColor = Constant.Colors.black
    }
    private func callRequest(
        searchText: String,
        startPage: Int,
        sorting: SortedItem
    ) {
        let url = makeURL(
            with: searchText,
            with: startPage,
            sorting: sorting
        )
        let header = makeHeader()
        
        AF.request(
            url,
            headers: header
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: Search.self) { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let value):
                if value.start == value.totalPages {
                    isLastPage = true
                }
                
                if self.page == 1 {
                    self.searchedResult = value
                } else {
                    self.searchedResult.items.append(contentsOf: value.items)
                }
                
                self.totalItemLabel.text =
                "\(self.searchedResult.totalItems)개의 검색 결과"
                self.itemCollectionView.reloadData()
            case .failure(let error):
                // 재검색 유도
                print(error)
            }
        }
    }
    private func makeURL(
        with searchText: String,
        with startPage: Int,
        sorting: SortedItem
    ) -> String {
        let baseURLString = Constant.Endpoint.baseURL
        let queryParams: [String: String] = [
            "query" : searchText,
            "display" : String(30),
            "start" : String(startPage),
            "sort" : sorting.query
        ]
        let query = queryParams.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        
        print(query)
        return baseURLString + query
    }
    private func makeHeader() -> HTTPHeaders {
        let client_ID = Bundle.main.object(
            forInfoDictionaryKey: "NAVER_SEARCH_API_CLIENT_ID"
        ) as? String ?? ""
        let client_Secret = Bundle.main.object(
            forInfoDictionaryKey: "NAVER_SEARCH_API_CLIENT_SECRET"
        ) as? String ?? ""
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": client_ID,
            "X-Naver-Client-Secret": client_Secret
        ]
        return header
    }
    @objc private func customBackBtnTapped() {
        navigationController?.popViewController(animated: true)
    }
    private func collectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(Constant.CollectionCell.spacing.rawValue)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constant.CollectionCell.spacing.rawValue
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Constant.CollectionCell.spacing.rawValue,
            bottom: 0,
            trailing: Constant.CollectionCell.spacing.rawValue
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}

extension SearchResultViewController
: UICollectionViewDelegate, UICollectionViewDataSource
, UICollectionViewDataSourcePrefetching {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return searchedResult.items.count
    }
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchedItemCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchedItemCollectionViewCell
        else { return UICollectionViewCell() }
        cell.configureUI(item: searchedResult.items[indexPath.item])
        return cell
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        prefetchItemsAt indexPaths: [IndexPath]
    ) {
        print(#function, indexPaths)
        
        for path in indexPaths {
            if searchedResult.items.count - 10 == path.item 
                && isLastPage == false {
                page += 1
                guard let searchedText else { return }
                callRequest(
                    searchText: searchedText,
                    startPage: page,
                    sorting: sorting
                )
                
            }
        }
    }
    
}
