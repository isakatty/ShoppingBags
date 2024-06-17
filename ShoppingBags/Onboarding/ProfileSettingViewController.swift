//
//  ProfileSettingViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/14/24.
//

import UIKit

public final class ProfileSettingViewController: UIViewController {
    private lazy var profileImgStr: String = UserDefaultsManager.shared
        .getValue(forKey: .profileImgTitle) 
    ?? "profile_" + "\(Int.random(in: 0...11))"
    
    private lazy var profileImg: CircledProfileViewBtn = {
        let profileView = CircledProfileViewBtn()
        profileView.clearButton.addTarget(
            self,
            action: #selector(profileImgClicked),
            for: .touchUpInside
        )
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
        
        fetchData()
        configureNaviTitle(title: ViewTitle.profile.rawValue)
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: UserDefaults fetch -> Img 변경해줘야함.
        fetchData()
        configureUI()
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
    private func fetchData() {
        profileImgStr = UserDefaultsManager.shared
            .getValue(forKey: .profileImgTitle)
        ?? "profile_" + "\(Int.random(in: 0...11))"
    }
    private func configureUI() {
        profileImg.configureUI(
            img: getImage(from: profileImgStr),
            isSelected: true
        )
    }
    func getImage(from string: String) -> UIImage? {
        guard let profileCase = Constant.ProfileImages.allCases.first(
            where: { $0.rawValue == string }
        ) else { return nil }
        return profileCase.profileImg
    }
    @objc private func profileImgClicked() {
        let vc = EditingProfileImgViewController()
        vc.selectedImgName = profileImgStr
        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
    @objc private func checkBtnTapped() {
        print(#function)
    }
}
