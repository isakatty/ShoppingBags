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
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Constant.Colors.white
        appearance.shadowColor = Constant.Colors.mediumGray
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance 
        = navigationController?.navigationBar.standardAppearance
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
    func getImage(from string: String) -> UIImage? {
        guard let profileCase = Constant.ProfileImages.allCases.first(
            where: { $0.rawValue == string }
        ) else { return nil }
        return profileCase.profileImg
    }
    func showAlert(
        title: String,
        body: String,
        fineTitle: String,
        completionHandler: @escaping (UIAlertAction) -> Void
    ) {
        let alert = UIAlertController(
            title: title,
            message: body,
            preferredStyle: .alert
        )
        
        let cancel = UIAlertAction(
            title: "취소",
            style: .cancel
        )
        let check = UIAlertAction(
            title: fineTitle,
            style: .destructive
        ) { action in
            completionHandler(action)
        }
        
        [cancel, check]
            .forEach { alert.addAction($0) }
        
        present(
            alert,
            animated: true
        )
    }
    func configureRightBarBtn(
        btnTitle: String,
        btnAction: Selector?
    ) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: btnTitle,
            style: .plain,
            target: self,
            action: btnAction
        )
    }
    func configureRightBarBtn(
        btnImg: UIImage?,
        btnAction: Selector?
    ) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: btnImg,
            style: .plain,
            target: self,
            action: btnAction
        )
    }
    func changeWindows(to viewController: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first 
        as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate

        if viewController is TabBarController {
            sceneDelegate?.window?.rootViewController = viewController
        } else {
            let nav = UINavigationController(rootViewController: viewController)
            sceneDelegate?.window?.rootViewController = nav
        }
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
