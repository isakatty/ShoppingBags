//
//  UITableViewCell+.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

protocol ReuseIdentifier {
    static var identifier: String { get }
}

extension UITableViewCell: ReuseIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}
