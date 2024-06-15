//
//  SettingViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

public final class SettingViewController: UIViewController {
    
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
    }
    private func configureNavigationBar() {
        navigationItem.title = "SETTING"
        navigationController?.navigationBar.tintColor = Constant.Colors.black
    }
}
