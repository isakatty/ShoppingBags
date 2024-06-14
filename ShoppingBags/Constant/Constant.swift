//
//  Constant.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/14/24.
//

import UIKit

enum Constant {
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
    
    enum SystemImages {
        static let leftChevron = UIImage(systemName: "chevron.left")
        static let rightChevron = UIImage(systemName: "chevron.right")
        static let clock = UIImage(systemName: "clock")
        static let xmark = UIImage(systemName: "xmark")
        static let camera = UIImage(systemName: "camera.fill")
        static let person = UIImage(systemName: "person")
        static let glass = UIImage(systemName: "magnifyingglass")
    }
    
}
