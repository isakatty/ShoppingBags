//
//  ViewTitle.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/17/24.
//

import Foundation

enum ViewTitle: String {
    case profile = "PROFILE SETTING"
    case setting = "SETTING"
    case editSetting = "EDIT PROFILE"
    case main
    
    var mainTitle: String {
        switch self {
        case .main:
            let userName: String = UserDefaultsManager.shared
                .getValue(forKey: .nickname) ?? "UserName"
            
            return "\(userName)'s MEANING OUT"
        case .profile, .setting, .editSetting:
            return self.rawValue
        }
    }
}
