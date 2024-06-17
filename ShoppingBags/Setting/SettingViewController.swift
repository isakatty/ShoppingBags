//
//  SettingViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

/*
 TODO: 화면 load될 때 username, profileImg, signUpDate 가져와서 뷰에 띄워줘야함.
 */

public final class SettingViewController: UIViewController {
    private let profileView = SettingProfileView()
    private lazy var settingTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 50
        table.register(
            SettingTableViewCell.self,
            forCellReuseIdentifier: SettingTableViewCell.identifier
        )
        return table
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureBtn()
    }
    
    private func configureHierarchy() {
        [profileView, settingTableView]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        let safeArea = view.safeAreaLayoutGuide
        profileView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(16)
            make.leading.trailing.equalTo(safeArea)
            make.height.equalTo(profileView.snp.width).multipliedBy(0.15)
        }
        
        settingTableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(8)
            make.bottom.trailing.leading.equalTo(safeArea)
        }
    }
    private func configureNavigationBar() {
        navigationItem.title = "SETTING"
        navigationController?.navigationBar.tintColor = Constant.Colors.black
    }
    private func resetData() {
        SaveData.allCases
            .forEach { UserDefaultsManager.shared.removeValue(forKey: $0) }
    }
    private func returnOnboarding() {
        let windowScene = UIApplication.shared.connectedScenes.first 
        as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let navigationController = UINavigationController(
            rootViewController: OnboardingViewController()
        )
        sceneDelegate?.window?.rootViewController = navigationController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    private func configureBtn() {
        profileView.clearBtn.addTarget(
            self,
            action: #selector(clearBtnTapped),
            for: .touchUpInside
        )
    }
    /// profile 선택시 화면 전환
    @objc private func clearBtnTapped() {
        print(#function)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return Setting.allCases.count
    }
    
    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingTableViewCell.identifier,
            for: indexPath
        ) as? SettingTableViewCell else { return UITableViewCell() }
        cell.configureUI(index: indexPath.row)
        return cell
    }
    /// select 여부를 return 값으로 제어함. true 가능 / false 불가능
    public func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath
    ) -> Bool {
        return indexPath.row == Setting.allCases.endIndex - 1
    }
    public func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let alert = UIAlertController(
            title: "탈퇴하기",
            message: "탈퇴를 하면 데이터가 모두 초기화 됩니다. 탈퇴하시겠습니까?",
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(
            title: "확인",
            style: .cancel) { [weak self] _ in
                // TODO: 데이터 삭제 함수 호출
                self?.returnOnboarding()
            }
        let cancelAction = UIAlertAction(
            title: "취소",
            style: .destructive
        )
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        present(
            alert,
            animated: true
        )
    }
}
