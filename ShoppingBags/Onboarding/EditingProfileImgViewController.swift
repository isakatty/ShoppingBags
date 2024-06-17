//
//  EditingProfileImgViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/17/24.
//

import UIKit

public final class EditingProfileImgViewController: UIViewController {
    // profile img 전달 받아야함.
    public var selectedImgName: String?
    private lazy var mainCircledImg = CircledProfileView()
    private lazy var imgCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout()
        )
        collection.delegate = self
        collection.dataSource = self
        collection.register(
            EditingCollectionViewCell.self,
            forCellWithReuseIdentifier: EditingCollectionViewCell.identifier
        )
        return collection
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNaviTitle(title: ViewTitle.profile.rawValue)
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        
        guard let selectedImgName else { return }
        configureUI(img: getImage(from: selectedImgName))
    }
    
    private func configureHierarchy() {
        [mainCircledImg, imgCollectionView]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        let safeArea = view.safeAreaLayoutGuide
        
        mainCircledImg.snp.makeConstraints { make in
            make.top.equalTo(safeArea).inset(16)
            make.leading.trailing.equalTo(safeArea).inset(140)
            make.height.equalTo(mainCircledImg.snp.width)
        }
        imgCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mainCircledImg.snp.bottom)
            make.leading.trailing.equalTo(safeArea)
            make.height.equalTo(imgCollectionView.snp.width)
            make.centerX.equalTo(safeArea)
        }
    }
    private func configureUI(img: UIImage?) {
        mainCircledImg.configureUI(img: img, isSelected: true)
    }
    private func collectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.2),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.2)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 4
        )
        group.interItemSpacing = .fixed(
            Constant.CollectionCell.spacing.rawValue
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constant.CollectionCell.spacing.rawValue
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Constant.CollectionCell.spacing.rawValue,
            leading: Constant.CollectionCell.spacing.rawValue,
            bottom: Constant.CollectionCell.spacing.rawValue,
            trailing: Constant.CollectionCell.spacing.rawValue
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    private func getImage(from string: String) -> UIImage? {
        guard let profileCase = Constant.ProfileImages.allCases.first(
            where: { $0.rawValue == string }
        ) else { return nil }
        return profileCase.profileImg
    }
    @objc private func cellImgTapped(sender: UIButton) {
        let profileImage = Constant.ProfileImages.allCases[sender.tag].rawValue
        
        UserDefaultsManager.shared.saveValue(
            profileImage,
            forKey: .profileImgTitle
        )
        configureUI(img: getImage(from: profileImage))
        imgCollectionView.reloadData()
    }
}

extension EditingProfileImgViewController
: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        return Constant.ProfileImages.allCases.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EditingCollectionViewCell.identifier,
            for: indexPath) as? EditingCollectionViewCell,
              let selectedImgName else { return UICollectionViewCell() }
        
        let savedImg = UserDefaultsManager.shared
            .getValue(forKey: .profileImgTitle) ?? selectedImgName
        var alreadySelected = false
        
        if Constant.ProfileImages(rawValue: savedImg)
            == Constant.ProfileImages.allCases[indexPath.item] {
            alreadySelected = true
        }
        
        cell.configureUI(
            img: Constant.ProfileImages.allCases[indexPath.item].profileImg,
            isSelected: alreadySelected
        )
        cell.profileImage.clearButton.addTarget(
            self,
            action: #selector(cellImgTapped),
            for: .touchUpInside
        )
        cell.profileImage.clearButton.tag = indexPath.item
        return cell
    }
}
