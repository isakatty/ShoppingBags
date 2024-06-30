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
        configureUI(text: nameTextField.text!)
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
    func configureUI(text: String) {
        do {
            let state = try validateTextField(text: text)
            if state {
                configurLabel(
                    text: "사용 가능한 닉네임입니다.",
                    color: Constant.Colors.darkGray
                )
            }
        } catch {
            configurLabel(
                text: error.localizedDescription,
                color: Constant.Colors.orange
            )
        }
    }
    private func configurLabel(text: String, color: UIColor?) {
        seperateBar.backgroundColor = color
        statusLabel.textColor = color
        statusLabel.text = text
    }
    
    private func validateTextField(text: String) throws -> Bool {
        let specialIcons: [String] = ["@", "#", "$", "%"]
        
        let textWithoutSpacing = text.trimmingCharacters(in: .whitespaces)
        
        guard textWithoutSpacing.count >= 2
                && textWithoutSpacing.count < 10
        else {
            print("2,10 조건 에러")
            validatePass = false
            changedValid?(validatePass)
            throw NicknameError.failedTextCondition
        }
        
        guard !textWithoutSpacing.contains(where: {
            specialIcons.contains(String($0)) }
        ) else {
            print("아이콘")
            validatePass = false
            changedValid?(validatePass)
            throw NicknameError.includeIcons
        }
        guard !textWithoutSpacing.contains(where: { $0.isNumber }) else {
            print("숫자포함")
            validatePass = false
            changedValid?(validatePass)
            throw NicknameError.includeNumbers
        }
        
        validatePass = true
        changedValid?(validatePass)
        return validatePass
    }
}

extension NameTextFieldView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        configureUI(text: text)
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
        configureUI(text: updatedText)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        configureUI(text: text)
        self.endEditing(true)
        return true
    }
}
