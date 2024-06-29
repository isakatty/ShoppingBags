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
        
        let searchVC = SearchViewController()
        let settingVC = SettingViewController()
        
        let firstTab = makeNavigationController(
            with: searchVC,
            title: "검색",
            tabBarImg: Constant.SystemImages.glass,
            tag: 0
        )
        let secondTab = makeNavigationController(
            with: settingVC,
            title: "설정",
            tabBarImg: Constant.SystemImages.person,
            tag: 1
        )
        
        setViewControllers(
            [
                firstTab,
                secondTab
            ],
            animated: true
        )
    }
    
    private func makeNavigationController(
        with vc: UIViewController,
        title: String,
        tabBarImg: UIImage?,
        tag: Int
    ) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(
            title: title,
            image: tabBarImg,
            tag: tag
        )
        return nav
    }
}
