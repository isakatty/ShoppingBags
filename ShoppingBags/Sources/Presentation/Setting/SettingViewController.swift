//
//  SettingViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

final class SettingViewController: UIViewController {
    private var nickname: String = ""
    private var profileImgTitle: String = ""
    private var signupDate: String = ""
    private lazy var profileView: SettingProfileView = {
        let view = SettingProfileView()
        view.clearBtn.addTarget(
            self,
            action: #selector(clearBtnTapped),
            for: .touchUpInside
        )
        return view
    }()
    private let separateBar = UIView()
    private lazy var settingTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 50
        table.register(
            SettingTableViewCell.self,
            forCellReuseIdentifier: SettingTableViewCell.identifier
        )
        table.isScrollEnabled = false
        table.separatorInset = .init(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0
        )
        table.separatorColor = Constant.Colors.mediumGray
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        configureNaviTitle(title: ViewTitle.setting.rawValue)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //  데이터 fetch
        fetchData()
        configureUI()
    }
    
    private func configureHierarchy() {
        [profileView, separateBar, settingTableView]
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
        separateBar.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(safeArea)
            make.height.equalTo(1)
        }
        
        settingTableView.snp.makeConstraints { make in
            make.top.equalTo(separateBar.snp.bottom)
            make.bottom.trailing.leading.equalTo(safeArea)
        }
    }
    private func resetData() {
        SaveData.allCases
            .forEach { UserDefaultsManager.shared.removeValue(forKey: $0) }
    }
    private func configureUI() {
        separateBar.backgroundColor = Constant.Colors.lightGray
        profileView.configureUI(
            img: getImage(from: profileImgTitle),
            nicknameTitle: nickname,
            dateTitle: signupDate
        )
    }
    private func fetchData() {
        nickname = SaveData.nickname.fetchedData
        signupDate = SaveData.signupDate.fetchedData
        profileImgTitle = SaveData.profileImgTitle.fetchedData
        
        settingTableView.reloadData()
    }
    /// profile 선택시 화면 전환
    @objc private func clearBtnTapped() {
        let vc = ProfileSettingViewController(viewFlow: .setting)
        vc.imageName = profileImgTitle
        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return Setting.allCases.count
    }
    
    func tableView(
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
    func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath
    ) -> Bool {
        return indexPath.row == Setting.allCases.endIndex - 1
    }
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.reloadRows(at: [indexPath], with: .none)
        showAlert(
            title: "탈퇴하기",
            body: "탈퇴하면 모든 데이터가 초기화 됩니다. 탈퇴하시겠습니까?",
            fineTitle: "확인"
        ) { [weak self] _ in
            guard let self else { return }
            changeWindows(to: OnboardingViewController())
            self.resetData()
        }
    }
}
