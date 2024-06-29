//
//  ItemDetailWebViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/16/24.
//

import UIKit
import WebKit

final class ItemDetailWebViewController: UIViewController {
    var itemInfo: Item?
    private var isContainedItem: Bool?
    private let webView = WKWebView()
    private var favItems: [String] = UserDefaultsManager.shared
        .getValue(forKey: .shoppingBags) ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar(item: itemInfo)
        configureHierarchy()
        configureLayout()
        configureWebView(urlString: itemInfo?.storeLink)
    }
    
    private func configureHierarchy() {
        view.addSubview(webView)
    }
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        let safeArea = view.safeAreaLayoutGuide
        webView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
    private func configureWebView(urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        
        webView.load(URLRequest(url: url))
    }
    private func configureNavigationBar(item: Item?) {
        navigationItem.title = item?.formattedItemName
        configureNavigationBar()
        configureRightBarBtn(
            btnImg: configureBagsUI(item: item)?
                .withRenderingMode(.alwaysOriginal),
            btnAction: #selector(shoppingBagsTapped)
        )
        navigationController?.navigationBar.tintColor = Constant.Colors.black
    }
    private func configureBagsUI(item: Item?) -> UIImage? {
        isContainedItem = favItems.contains(item?.productId ?? "")
        guard let isContainedItem else { return Constant.Images.likeUnselected }
        return isContainedItem
        ? Constant.Images.likeSelected
        : Constant.Images.likeUnselected
    }
    @objc private func shoppingBagsTapped(sender: UIBarButtonItem) {
        guard let itemInfo else { return }
        if favItems.contains(itemInfo.productId) {
            favItems.removeAll { $0 == itemInfo.productId }
            UserDefaultsManager.shared.saveValue(
                favItems,
                forKey: .shoppingBags
            )
        } else {
            favItems.append(itemInfo.productId)
            UserDefaultsManager.shared.saveValue(
                favItems,
                forKey: .shoppingBags
            )
        }
        navigationItem.rightBarButtonItem?.image = configureBagsUI(
            item: itemInfo)?.withRenderingMode(.alwaysOriginal)
    }
}
