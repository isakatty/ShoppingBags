//
//  NameTextFieldView.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/14/24.
//

import UIKit

final class NameTextFieldView: BaseView {
    var changedValid: ((Bool) -> Void)?
    var validatePass: Bool = false
    var textFieldStatus: TextFieldStatus = .includeIcons
    lazy var nameTextField: UITextField = {
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
        textField.delegate = self
        return textField
    }()
    private let seperateBar = UIView()
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = Constant.Colors.orange
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI(status: textFieldStatus)
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
    func configureUI(status: TextFieldStatus) {
        switch status {
        case .pass:
            validatePass = true
            seperateBar.backgroundColor = status.textColor
            statusLabel.textColor = status.textColor
            statusLabel.text = status.rawValue
        case .failedTextCondition, .includeIcons, .includedNumbers:
            validatePass = false
            seperateBar.backgroundColor = Constant.Colors.lightGray
            statusLabel.textColor = Constant.Colors.orange
            statusLabel.text = status.rawValue
        }
        changedValid?(validatePass)
    }
    private func validateTextField(text: String) -> TextFieldStatus {
        let specialIcons: [String] = ["@", "#", "$", "%"]
        if text.contains(where: { $0.isNumber }) {
            return .includedNumbers
        } else if text.contains(
            where: { specialIcons.contains(String($0)) }
        ) {
            return .includeIcons
        } else if text.count < 3 {
            return .failedTextCondition
        } else if text.count > 10 {
            return .failedTextCondition
        } else {
            return .pass
        }
    }
}

extension NameTextFieldView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textFieldStatus = validateTextField(text: text)
        configureUI(status: textFieldStatus)
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let currentText = textField.text,
              let stringRange = Range(
                range,
                in: currentText
              )
        else { return false }
        
        let updatedText = currentText.replacingCharacters(
            in: stringRange,
            with: string
        )
        textFieldStatus = validateTextField(text: updatedText)
        configureUI(status: textFieldStatus)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        textFieldStatus = validateTextField(text: text)
        configureUI(status: textFieldStatus)
        return textFieldStatus == .pass
    }
}
