//
//  OnboardingViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/14/24.
//

import UIKit

import SnapKit

public final class OnboardingViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MeaningOut"
        label.font = .systemFont(
            ofSize: 30,
            weight: .heavy
        )
        label.textColor = Constant.Colors.orange
        return label
    }()
    private let onboardingImage: UIImageView = {
        let img = UIImageView()
        img.image = Constant.Images.onBoarding?
            .withRenderingMode(.alwaysOriginal)
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    private lazy var startBtn: RoundedButton = {
        let btn = RoundedButton(titleForButton: "시작하기")
        btn.addTarget(
            self,
            action: #selector(startBtnTapped),
            for: .touchUpInside
        )
        return btn
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        [
            titleLabel,
            onboardingImage,
            startBtn
        ]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        let safeArea = view.safeAreaLayoutGuide
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(100)
            make.centerX.equalTo(safeArea)
        }
        onboardingImage.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(100)
            make.leading.trailing.equalTo(safeArea).inset(110)
            make.height.equalTo(self.onboardingImage.snp.width)
            make.center.equalTo(view)
        }
        startBtn.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea).inset(10)
            make.leading.trailing.equalTo(safeArea).inset(50)
            make.height.equalTo(40)
        }
    }
    
    @objc private func startBtnTapped() {
        let vc = ProfileSettingViewController()
        
        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
}
