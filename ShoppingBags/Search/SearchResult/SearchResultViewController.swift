//
//  SearchResultViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

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
        fetchData(
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
    private func fetchData(
        searchText: String?,
        startPage: Int,
        sorting: SortedItem
    ) {
        NetworkManager.shared.callRequest(
            searchText: searchText,
            startPage: startPage,
            sorting: sorting) { [weak self] search in
                guard let self = self else { return }
                if search.total == 0 {
                    showAlert(
                        title: "검색하신 결과가 없습니다.",
                        body: "입력하신 \(searchedText ?? "")에 관련된 정보가 없습니다.",
                        fineTitle: "돌아가기"
                    ) { [weak self] _ in
                        guard let self else { return }
                        navigationController?.popViewController(animated: true)
                    }
                } else {
                    if search.start == search.totalPages {
                        isLastPage = true
                    }
                    if self.page == 1 {
                        self.searchedResult = search
                        self.itemCollectionView.scrollsToTop = true
                    } else {
                        self.searchedResult.items.append(
                            contentsOf: search.items
                        )
                    }
                    
                    self.totalItemLabel.text =
                    "\(self.searchedResult.totalItems)개의 검색 결과"
                    self.itemCollectionView.reloadData()
                }
            }
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
        fetchData(
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
                page += 30
                guard let searchedText else { return }
                fetchData(
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
