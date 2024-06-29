//
//  Setting.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/16/24.
//

import Foundation

public enum Setting: String, CaseIterable {
    case shoppingList = "나의 장바구니 목록"
    case question = "자주 묻는 질문"
    case inquiry = "1:1 문의"
    case alert = "알림 설정"
    case secession = "탈퇴하기"
    
    var shoppingItem: String {
        switch self {
        case .shoppingList:
            let shoppingBags: [String] = UserDefaultsManager.shared.getValue(
                forKey: SaveData.shoppingBags
            ) ?? []
            
            let shopping = "\(shoppingBags.count)개의 상품"
            
            return shopping
        case .question, .inquiry, .alert, .secession:
            return ""
        }
    }
}
