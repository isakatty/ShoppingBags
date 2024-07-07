//
//  TabBarController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
    }
    private func configureTabBar() {
        tabBar.tintColor = Constant.Colors.orange
        tabBar.unselectedItemTintColor = Constant.Colors.lightGray
        
        let viewControllers = [
            SearchViewController(),
            FavoriteViewController(),
            SettingViewController()
        ]
        
        setViewControllers(
            configureTabs(vcGroup: viewControllers),
            animated: true
        )
    }
    
    private func configureTabs(vcGroup: [UIViewController]) 
    -> [UINavigationController] {
        return vcGroup.enumerated().compactMap { (index, vc) in
            let tabbarCase = Tabbar(rawValue: index)
            let tab = UITabBarItem(
                title: tabbarCase?.tabbarName,
                image: tabbarCase?.tabBarImage,
                tag: index
            )
            let navController = UINavigationController(rootViewController: vc)
            navController.tabBarItem = tab
            return navController
        }
    }
}
