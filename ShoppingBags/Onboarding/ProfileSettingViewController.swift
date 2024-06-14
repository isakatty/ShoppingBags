//
//  ProfileSettingViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/14/24.
//

import UIKit

public final class ProfileSettingViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
    }
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Constant.SystemImages.leftChevron,
            style: .plain,
            target: self,
            action: #selector(backBtnTapped)
        )
        navigationItem.title = "PROFILE SETTING"
        navigationController?.navigationBar.tintColor = Constant.Colors.black
    }
    
    private func configureHierarchy() {
        
    }
    private func configureLayout() {
        view.backgroundColor = .systemBackground
    }
    @objc private func backBtnTapped() {
        print(#function)
    }
}
