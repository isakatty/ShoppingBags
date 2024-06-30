//
//  TextFieldStatus.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/14/24.
//

import UIKit

enum NicknameError: Error {
    case includeIcons
    case includeNumbers
    case failedTextCondition
}
extension NicknameError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .includeIcons:
            "닉네임에 @, #, $, %는 포함할 수 없어요"
        case .includeNumbers:
            "닉네임에 숫자는 포함할 수 없어요"
        case .failedTextCondition:
            "2글자 이상 10글자 미만으로 설정해주세요"
        }
    }
}
