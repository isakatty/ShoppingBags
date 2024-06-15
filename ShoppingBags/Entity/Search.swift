//
//  Search.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import Foundation

struct Search: Codable {
    let total: Int
    var start: Int
    let display: Int
    let items: [Item]
}

struct Item: Codable {
    let title: String
    let itemImage: String
    let storeLink: String
    let mallName: String
    let productId: String
    let lprice: String
    
    enum CodingKeys: String, CodingKey {
        case title, mallName, productId, lprice
        case itemImage = "image"
        case storeLink = "link"
    }
}
