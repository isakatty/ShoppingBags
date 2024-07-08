//
//  Favorite.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 7/8/24.
//

import Foundation

import RealmSwift

final class Favorite: Object {
    @Persisted(primaryKey: true) var productId: String
    @Persisted var storeLink: String
    @Persisted(indexed: true) var itemName: String
    @Persisted var itemImage: String
    @Persisted var itemPrice: String
    
    @Persisted(originProperty: "favs") var main: LinkingObjects<Folder>
    
    convenience init(
        productId: String,
        storeLink: String,
        itemName: String,
        itemImage: String,
        itemPrice: String
    ) {
        self.init()
        self.productId = productId
        self.storeLink = storeLink
        self.itemName = itemName
        self.itemImage = itemImage
        self.itemPrice = itemPrice
    }
    
}
