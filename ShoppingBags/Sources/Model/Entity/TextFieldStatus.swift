//
//  TextFieldStatus.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/14/24.
//

import UIKit

public enum TextFieldStatus: String, CaseIterable {
    case includeIcons = "닉네임에 @,#,$,%는 포함할 수 없어요"
    case failedTextCondition = "2글자 이상 10글자 미만으로 설정해주세요"
    case includedNumbers = "닉네임에 숫자는 포함할 수 없어요"
    case pass = "사용할 수 있는 닉네임이에요"
    
    var textColor: UIColor? {
        switch self {
        case .pass:
            return Constant.Colors.darkGray
        case .failedTextCondition, .includeIcons, .includedNumbers:
            return Constant.Colors.orange
        }
    }
}
