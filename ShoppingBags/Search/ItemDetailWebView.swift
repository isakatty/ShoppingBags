//
//  ItemDetailWebView.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/16/24.
//

import UIKit
import WebKit

public final class ItemDetailWebViewController: UIViewController {
    public var itemInfo: Item?
    private let webView = WKWebView()
    
    public override func viewDidLoad() {
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Constant.SystemImages.leftChevron,
            style: .plain,
            target: self,
            action: #selector(customBackBtnTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Constant.Images.likeSelected,
            style: .plain,
            target: self,
            action: #selector(shoppingBagsTapped)
        )
        navigationController?
            .interactivePopGestureRecognizer?.delegate = nil
        navigationController?.navigationBar.tintColor = Constant.Colors.black
    }
    @objc private func customBackBtnTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func shoppingBagsTapped() {
        print("장바구니 버튼 눌린거 fetch 되어야함.")
    }
}
