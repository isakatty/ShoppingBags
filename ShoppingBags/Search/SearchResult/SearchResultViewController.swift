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
    private var favItems: [String] = UserDefaultsManager.shared
        .getValue(forKey: .shoppingBags) ?? []
    private var sorting: SortedItem = .accuracy
    private var searchedResult: Search = Search(
        total: 0,
        start: 0,
        display: 0,
        items: []
    )
    private let totalItemLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.bold15
        label.textColor = Constant.Colors.orange
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
    private let sortingView = SearchResultSortingView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let searchedText else { return }
        
        configureNaviTitle(title: searchedText)
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureBtn()
        callRequest(
            searchText: searchedText,
            startPage: page,
            sorting: sorting
        )
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        itemCollectionView.reloadData()
    }
    private func configureHierarchy() {
        [totalItemLabel, sortingView, itemCollectionView]
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
        sortingView.snp.makeConstraints { make in
            make.top.equalTo(totalItemLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(safeArea)
            make.height.equalTo(30)
        }
        itemCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sortingView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(safeArea)
        }
    }
    private func configureBtn() {
        [
            sortingView.accuracyBtn,
            sortingView.highestBtn,
            sortingView.latestBtn,
            sortingView.lowestBtn
        ]
            .forEach { btn in
                btn.addTarget(
                    self,
                    action: #selector(sortingBtnTapped),
                    for: .touchUpInside
                )
            }
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
                if value.total == 0 {
                    addAlert()
                } else {
                    if value.start == value.totalPages {
                        isLastPage = true
                    }
                    
                    if self.page == 1 {
                        self.searchedResult = value
                        self.itemCollectionView.scrollsToTop = true
                    } else {
                        self.searchedResult.items.append(contentsOf: value.items)
                    }
                    
                    self.totalItemLabel.text =
                    "\(self.searchedResult.totalItems)개의 검색 결과"
                    self.itemCollectionView.reloadData()
                }
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
        
        guard let encodedQuery = query
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else { return "" }
        
        return baseURLString + encodedQuery
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
    @objc private func sortingBtnTapped(sender: SortingButton) {
        let btns = [
            sortingView.accuracyBtn,
            sortingView.highestBtn,
            sortingView.latestBtn,
            sortingView.lowestBtn
        ]
        
        btns.forEach { $0.configureUI() }
        sender.configureUISelected()
        
        guard let searchedText else { return }
        callRequest(
            searchText: searchedText,
            startPage: 1,
            sorting: sender.sortCondition
        )
    }
    @objc private func shoppingBagBtnTapped(sender: UIButton) {
        if favItems.contains(searchedResult.items[sender.tag].productId) {
            favItems.removeAll {
                $0 == searchedResult.items[sender.tag].productId
            }
            UserDefaultsManager.shared.saveValue(
                favItems,
                forKey: .shoppingBags
            )
        } else {
            favItems.append(searchedResult.items[sender.tag].productId)
            UserDefaultsManager.shared.saveValue(
                favItems,
                forKey: .shoppingBags
            )
        }
        itemCollectionView.reloadItems(
            at: [IndexPath(
                item: sender.tag,
                section: 0
            )]
        )
    }
    private func addAlert() {
        let alert = UIAlertController(
            title: "검색한 결과가 없습니다.",
            message: "입력하신 \(searchedText ?? "")에 관련된 데이터가 없습니다.",
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "돌아가기",
            style: .destructive
        ) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        present(
            alert,
            animated: true
        )
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
        cell.shoppingBtn.addTarget(
            self,
            action: #selector(shoppingBagBtnTapped),
            for: .touchUpInside
        )
        cell.configureUI(
            item: searchedResult.items[indexPath.item],
            tag: indexPath.item
        )
        return cell
    }
    public func collectionView(
        _ collectionView: UICollectionView,
        prefetchItemsAt indexPaths: [IndexPath]
    ) {
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
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        itemCollectionView.reloadData()
        let vc = ItemDetailWebViewController()
        vc.itemInfo = searchedResult.items[indexPath.item]
        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
}
