//
//  Constant.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/14/24.
//

import UIKit

enum Constant {
    enum Endpoint {
        static let baseURL = "https://openapi.naver.com/v1/search/shop.json?"
    }
    
    enum Colors {
        static let orange = UIColor(named: "AccentColor")
        static let black = UIColor(named: "BasicBlack")
        static let white = UIColor(named: "BasicWhite")
        static let lightGray = UIColor(named: "GrayLight")
        static let mediumGray = UIColor(named: "GrayMedium")
        static let darkGray = UIColor(named: "GrayDark")
    }
    
    enum Images {
        static let empty = UIImage(named: "empty")
        static let onBoarding = UIImage(named: "launch")
        static let likeSelected = UIImage(named: "like_selected")
        static let likeUnselected = UIImage(named: "like_unselected")
    }
    
    enum ProfileImages: String, CaseIterable {
        case profile0 = "profile_0"
        case profile1 = "profile_1"
        case profile2 = "profile_2"
        case profile3 = "profile_3"
        case profile4 = "profile_4"
        case profile5 = "profile_5"
        case profile6 = "profile_6"
        case profile7 = "profile_7"
        case profile8 = "profile_8"
        case profile9 = "profile_9"
        case profile10 = "profile_10"
        case profile11 = "profile_11"
        
        var profileImg: UIImage? {
            return UIImage(named: self.rawValue)
        }
    }
    
    enum SystemImages {
        static let leftChevron = UIImage(systemName: "chevron.left")
        static let rightChevron = UIImage(systemName: "chevron.right")
        static let clock = UIImage(systemName: "clock")
        static let xmark = UIImage(systemName: "xmark")
        static let camera = UIImage(systemName: "camera.fill")
        static let person = UIImage(systemName: "person")
        static let glass = UIImage(systemName: "magnifyingglass")
        static let heart = UIImage(systemName: "heart")
    }
    
    enum Font {
        static let bold17 = UIFont.boldSystemFont(ofSize: 17)
        static let bold15 = UIFont.boldSystemFont(ofSize: 15)
        static let bold13 = UIFont.boldSystemFont(ofSize: 13)
        static let regular15 = UIFont.systemFont(ofSize: 15)
        static let regular14 = UIFont.systemFont(ofSize: 14)
        static let regular13 = UIFont.systemFont(ofSize: 13)
        static let light13 = UIFont.systemFont(
            ofSize: 13,
            weight: .light
        )
    }
    
    enum CornerRadius: CGFloat {
        case collectionViewImg = 10
        case shoppingBagBg = 4
    }
    
    enum CollectionCell: CGFloat {
        case spacing = 16
    }
    
}
