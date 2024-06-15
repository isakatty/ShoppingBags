//
//  SearchResultViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

public final class SearchResultViewController: UIViewController {
    public var searchedText: String?
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        
    }
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        let safeArea = view.safeAreaLayoutGuide
        
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
    private func callRequest() {
        
    }
    @objc private func customBackBtnTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
