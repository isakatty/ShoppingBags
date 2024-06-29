//
//  ProfileSettingViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/14/24.
//

import UIKit

public final class ProfileSettingViewController: UIViewController {
    public var imageName: String?
    public var viewFlow: ViewFlow
    private lazy var profileImgStr: String = UserDefaultsManager.shared
        .getValue(forKey: .profileImgTitle) 
    ?? "profile_" + "\(Int.random(in: 0...11))"
    private lazy var profileImg: CircledProfileView = {
        let profileView = CircledProfileView(hasClearBtn: true)
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
    
    public init(viewFlow: ViewFlow) {
        self.viewFlow = viewFlow
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
        configureUI()
    }
    private func configureHierarchy() {
        [profileImg, cameraView, nameTextField]
            .forEach { view.addSubview($0) }
        switch viewFlow {
        case .onboarding:
            view.addSubview(checkButton)
            configureNaviTitle(title: ViewTitle.profile.rawValue)
            configureNavigationBar()
        case .setting:
            configureNaviTitle(title: ViewTitle.editSetting.rawValue)
            configureNaviBarRightBtn()
            configureSettingBackBtn()
        }
    }
    private func configureSettingBackBtn() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Constant.SystemImages.leftChevron,
            style: .plain,
            target: self,
            action: #selector(settingBackBtnTapped)
        )
    }
    private func configureNaviBarRightBtn() {
        configureRightBarBtn(
            btnTitle: "저장",
            btnAction: #selector(saveBtnTapped)
        )
        navigationItem.rightBarButtonItem?.isEnabled
        = nameTextField.validatePass
        let attributes: [NSAttributedString.Key: Any] = [
            .font: Constant.Font.bold15
        ]
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(
            attributes,
            for: .normal
        )
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
        
        switch viewFlow {
        case .onboarding:
            checkButton.snp.makeConstraints { make in
                make.top.equalTo(nameTextField.snp.bottom).offset(30)
                make.leading.trailing.equalTo(safeArea).inset(16)
                make.height.equalTo(40)
            }
        case .setting:
            break
        }
        
    }
    private func fetchData() {
        profileImgStr = SaveData.profileImgTitle.fetchedData
    }
    private func configureUI() {
        profileImg.configureUI(
            img: getImage(from: profileImgStr),
            isSelected: true
        )
        switch viewFlow {
        case .onboarding:
            nameTextField.changedValid = { [weak self] changed in
                guard let self else { return }
                
                self.checkButton.isEnabled = changed
                self.checkButton.configureBtnUI(with: changed)
            }
        case .setting:
            let nickname: String? = SaveData.nickname.fetchedData
            
            nameTextField.nameTextField.text = nickname
            nameTextField.configureUI(status: .pass)
            nameTextField.changedValid = { [weak self] changed in
                guard let self else { return }
                self.navigationItem.rightBarButtonItem?.isEnabled = changed
            }
        }
    }
    @objc private func profileImgClicked() {
        let vc = EditingProfileImgViewController(
            viewFlow: viewFlow,
            selectedName: profileImgStr
        )
        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
    @objc private func checkBtnTapped() {
        if nameTextField.textFieldStatus == .pass {
            if let text = nameTextField.nameTextField.text {
                saveData(
                    imgName: profileImgStr,
                    nickname: text
                )
                changeWindow()
            }
        }
    }
    @objc private func saveBtnTapped() {
        if nameTextField.validatePass {
            saveData(
                imgName: profileImgStr,
                nickname: nameTextField.nameTextField.text ?? ""
            )
            navigationController?.popViewController(animated: true)
        }
    }
    @objc private func settingBackBtnTapped() {
        UserDefaultsManager.shared.saveValue(
            imageName,
            forKey: .profileImgTitle
        )
        navigationController?
            .interactivePopGestureRecognizer?.delegate = nil
        navigationController?.popViewController(animated: true)
    }
    private func saveData(
        imgName: String,
        nickname: String
    ) {
        UserDefaultsManager.shared.saveValue(
            imgName,
            forKey: .profileImgTitle
        )
        UserDefaultsManager.shared.saveValue(
            nickname,
            forKey: .nickname
        )
        switch viewFlow {
        case .onboarding:
            let date = Date()
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale(identifier: "ko-KR")
            dateFormat.dateFormat = "yyyy. MM. dd"
            
            UserDefaultsManager.shared.saveValue(
                dateFormat.string(
                    from: date
                ),
                forKey: .signupDate
            )
        case .setting: 
            break
        }
    }
    private func changeWindow() {
        let windowScene = UIApplication.shared.connectedScenes.first 
        as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        sceneDelegate?.window?.rootViewController = TabBarController()
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
