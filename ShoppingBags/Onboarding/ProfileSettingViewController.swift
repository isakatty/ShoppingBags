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
//        profileView.clearButton.addTarget(
//            self,
//            action: #selector(profileImgClicked),
//            for: .touchUpInside
//        )
        return profileView
    }()
    private let cameraView = CircledCameraView()
    private let nameTextField = NameTextFieldView()
    private lazy var checkButton: RoundedButton = {
        let btn = RoundedButton(titleForButton: "완료")
        btn.addTarget(
            self,
            action: #selector(checkBtnTapped),
            for: .touchUpInside
        )
        return btn
    }()
    
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
        [profileImg, cameraView, nameTextField, checkButton]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .systemBackground
        
        profileImg.snp.makeConstraints { make in
            make.centerX.equalTo(safeArea)
            make.top.equalTo(safeArea).offset(16)
            make.leading.trailing.equalTo(safeArea).inset(140)
            make.height.equalTo(profileImg.snp.width)
        }
        cameraView.snp.makeConstraints { make in
            make.bottom.equalTo(profileImg.snp.bottom)
            make.trailing.equalTo(profileImg.snp.trailing)
            make.width.height.equalTo(profileImg.snp.width).multipliedBy(0.25)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImg.snp.bottom).offset(30)
            make.leading.trailing.equalTo(safeArea)
            make.centerX.equalTo(safeArea)
            make.height.equalTo(nameTextField.snp.width).multipliedBy(0.07)
        }
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(30)
            make.leading.trailing.equalTo(safeArea).inset(16)
            make.height.equalTo(40)
        }
        
    }
    @objc private func backBtnTapped() {
        print(#function)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func profileImgClicked() {
        print(#function)
    }
    @objc private func checkBtnTapped() {
        print(#function)
    }
}
