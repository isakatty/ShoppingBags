//
//  Folder.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 7/8/24.
//

import Foundation

import RealmSwift

final class Folder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var folderName: String
    
    // 1:N Relationship을 위한
    @Persisted var favs: List<Favorite>
    
    convenience init(folderName: String) {
        self.init()
        self.folderName = folderName
    }
}
