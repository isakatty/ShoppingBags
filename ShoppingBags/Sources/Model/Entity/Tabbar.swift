//
//  Tabbar.swift
//  ShoppingBags
//
//  Created by Jisoo HAM on 6/29/24.
//

import UIKit

enum Tabbar: Int, CaseIterable {
    case searchItem = 0
    case setting
    
    var tabbarName: String {
        switch self {
        case .searchItem:
            "검색"
        case .setting:
            "설정"
        }
    }
    var tabBarImage: UIImage? {
        switch self {
        case .searchItem:
            Constant.SystemImages.glass
        case .setting:
            Constant.SystemImages.person
        }
    }
}
