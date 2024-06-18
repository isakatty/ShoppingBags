//
//  SaveData.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import Foundation

public enum SaveData: String, CaseIterable {
    case signupDate
    case nickname
    case profileImgTitle
    case searchedText
    case shoppingBags
    
    var fetchedData: String {
        switch self {
        case .signupDate:
            let date: String = UserDefaultsManager.shared
                .getValue(forKey: .signupDate) ?? ""
            return date
        case .nickname:
            let nickname: String = UserDefaultsManager.shared
                .getValue(forKey: .nickname) ?? ""
            return nickname
        case .profileImgTitle:
            let imgName: String = UserDefaultsManager.shared
                .getValue(forKey: .profileImgTitle)
            ?? "profile_" + "\(Int.random(in: 0...11))"
            return imgName
        case .searchedText:
            return ""
        case .shoppingBags:
            return ""
        }
    }
}
