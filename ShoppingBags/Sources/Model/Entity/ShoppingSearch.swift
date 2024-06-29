//
//  ShoppingSearch.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import Foundation

struct ShoppingSearch: Decodable {
    let total: Int
    var start: Int
    let display: Int
    var items: [SearchResultItem]
    
    var totalItems: String {
        return total.formatted(.number)
    }
    
    /// Pagenation을 위한 마지막 페이지를 구하는 연산 프로퍼티
    var totalPages: Int {
        if total % display == 0 {
            return total / display
        } else {
            return total / display + 1
        }
    }
}

struct SearchResultItem: Decodable {
    let itemName: String
    let itemImage: String
    let storeLink: String
    let mallName: String
    let productId: String
    let lprice: String
    
    enum CodingKeys: String, CodingKey {
        case mallName, productId, lprice
        case itemName = "title"
        case itemImage = "image"
        case storeLink = "link"
    }
    
    var formattedPrice: String {
        guard let changedToInt = Int(lprice) else { return "" }
        return changedToInt.formatted(.number) + "원"
    }
    
    var formattedItemName: String {
        return itemName.htmlEscaped
    }
}
