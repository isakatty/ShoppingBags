//
//  Search.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import Foundation

public struct Search: Codable {
    let total: Int
    var start: Int
    let display: Int
    let items: [Item]
    
    var totalItems: String {
        return total.formatted(.number)
    }
}

public struct Item: Codable {
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
