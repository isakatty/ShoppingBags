//
//  NameTextFieldView.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/14/24.
//

import UIKit

public final class NameTextFieldView: UIView {
    private var textFieldStatus: TextFieldStatus = .includeIcons
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.attributedPlaceholder = NSAttributedString(
            string: "닉네임을 입력해주세요 :)",
            attributes: [
                .foregroundColor: Constant.Colors.lightGray 
                ?? UIColor.lightGray,
                .font: UIFont.systemFont(ofSize: 16)
            ]
        )
        return textField
    }()
    private let seperateBar = UIView()
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = Constant.Colors.orange
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureTextField()
        configureUI(status: textFieldStatus)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [
            nameTextField,
            seperateBar,
            statusLabel
        ]
            .forEach { addSubview($0) }
    }
    private func configureLayout() {
        nameTextField.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(20)
        }
        seperateBar.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(nameTextField.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(seperateBar.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(32)
            make.bottom.greaterThanOrEqualToSuperview()
        }
    }
    private func configureTextField() {
        nameTextField.delegate = self
    }
    private func configureUI(status: TextFieldStatus) {
        switch status {
        case .pass:
            seperateBar.backgroundColor = status.textColor
            statusLabel.textColor = status.textColor
            statusLabel.text = status.rawValue
            
        case .failedTextCondition, .includeIcons, .includedNumbers:
            seperateBar.backgroundColor = Constant.Colors.lightGray
            statusLabel.textColor = Constant.Colors.orange
            statusLabel.text = status.rawValue
        }
    }
    
}

extension NameTextFieldView: UITextFieldDelegate {
    // TODO: 텍스트필드가 수정되기 시작할 때부터 유효성 검사를 해야함.
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        let specialIcons: [String] = [
            "@",
            "#",
            "$",
            "%"
        ]
        
    }
}
