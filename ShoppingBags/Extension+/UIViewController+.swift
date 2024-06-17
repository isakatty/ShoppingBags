//
//  UIViewController+.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/17/24.
//

import UIKit

extension UIViewController {
    func configureNaviTitle(title: String) {
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = Constant.Colors.black
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Constant.SystemImages.leftChevron,
            style: .plain,
            target: self,
            action: #selector(backBtnTapped)
        )
        navigationController?
            .interactivePopGestureRecognizer?.delegate = nil
    }
    @objc func backBtnTapped() {
        navigationController?.popViewController(animated: true)
    }
}
