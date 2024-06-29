//
//  UICollectionViewCell+.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/16/24.
//

import UIKit

extension UICollectionViewCell: ReuseIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}
