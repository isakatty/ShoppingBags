//
//  ProfileSettingViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/14/24.
//

import UIKit

public final class ProfileSettingViewController: UIViewController {
    
    private let imgName: String = "profile_" + String(Int.random(in: 0...11))
    private lazy var profileImg: CircledProfileView = {
        let profileView = CircledProfileView(
            img: UIImage(named: imgName),
            isSelected: true
        )
        profileView.clearButton.addTarget(
            self,
            action: #selector(profileImgClicked),
            for: .touchUpInside
        )
        return profileView
    }()
    private let cameraView = CircledCameraView()
    
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
        navigationController?
            .interactivePopGestureRecognizer?.delegate = nil
    }
    private func configureHierarchy() {
        [profileImg, cameraView]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .systemBackground
        
        profileImg.snp.makeConstraints { make in
            make.centerX.equalTo(safeArea)
            make.top.equalTo(safeArea)
            make.leading.trailing.equalTo(safeArea).inset(140)
            make.height.equalTo(profileImg.snp.width)
        }
        cameraView.snp.makeConstraints { make in
            make.bottom.equalTo(profileImg.snp.bottom)
            make.trailing.equalTo(profileImg.snp.trailing)
            make.width.height.equalTo(profileImg.snp.width).multipliedBy(0.25)
        }
    }
    @objc private func backBtnTapped() {
        print(#function)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func profileImgClicked() {
        print(#function)
    }
}
