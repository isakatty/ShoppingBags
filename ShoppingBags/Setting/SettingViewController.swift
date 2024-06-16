//
//  SettingViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

public final class SettingViewController: UIViewController {
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
    }
    
    private func configureHierarchy() {
        [settingTableView]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        let safeArea = view.safeAreaLayoutGuide
        settingTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
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
