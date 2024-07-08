//
//  FavoriteViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 7/8/24.
//

import UIKit

final class FavoriteViewController: BaseViewController {
    private var favItems: [Favorite] = [Favorite(
        productId: "",
        storeLink: "",
        itemName: "",
        itemImage: "",
        itemPrice: ""
    )]
    private lazy var favCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout()
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            SearchedItemCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchedItemCollectionViewCell.identifier
        )
        return collectionView
    }()
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.delegate = self
        search.placeholder = "검색"
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNaviTitle(title: "찜한 상품")
        fetchData()
        configureHierarchy()
        configureLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    private func configureHierarchy() {
        view.addSubview(favCollectionView)
        [searchBar, favCollectionView]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        let safeArea = view.safeAreaLayoutGuide
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(44)
        }
        favCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(4)
            make.bottom.horizontalEdges.equalTo(safeArea)
        }
    }
    
    private func fetchData() {
        do {
            let fetched = try RealmRepository()?.fetchFavorite()
            guard let fetched else {
                print("fetch 실패")
                return
            }
            favItems = fetched
        } catch {
            print("fetch 실패")
        }
        favCollectionView.reloadData()
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
        group.interItemSpacing = .fixed(
            Constant.CollectionCell.spacing.rawValue
        )
        
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
extension FavoriteViewController: UISearchBarDelegate {
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        favItems = RealmRepository()?.filterFav(searchText) ?? [Favorite(
            productId: "",
            storeLink: "",
            itemName: "",
            itemImage: "",
            itemPrice: ""
        )]
        favCollectionView.reloadData()
        
    }
}
extension FavoriteViewController
: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return favItems.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchedItemCollectionViewCell.identifier,
            for: indexPath ) as? SearchedItemCollectionViewCell
        else { return UICollectionViewCell() }
        // TODO: cell의 Action을 정의하고 UD delete 및 Realm에서 지워야함.
        let fav = favItems[indexPath.item]
        let searched = SearchResultItem(
            itemName: fav.itemName,
            itemImage: fav.itemImage,
            storeLink: fav.storeLink,
            mallName: "",
            productId: fav.productId,
            lprice: fav.itemPrice
        )
        cell.configureUI(item: searched, tag: indexPath.item)
        return cell
    }
    
}
