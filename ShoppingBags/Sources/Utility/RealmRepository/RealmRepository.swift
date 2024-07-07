//
//  RealmRepository.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 7/8/24.
//

import Foundation

import RealmSwift

final class RealmRepository {
    
//    private let realm = try! Realm()
    private var realm: Realm
    
    init?() {
        do {
            self.realm = try Realm()
        } catch {
            print("realm 생성 실패")
            return nil
        }
    }
    func fetchFavorite() throws -> [Favorite] {
        let favItems = realm.objects(Favorite.self)
        
        return Array(favItems)
    }
    
    func createFavorite(_ favorite: Favorite) throws {
        do {
            try realm.write {
                realm.add(favorite)
            }
        } catch {
            print("create 실패")
        }
    }
    func deleteFavorite(_ productId: String) throws {
        do {
            try realm.write {
                let deleteFav = realm.objects(Favorite.self)
                    .where { $0.productId == productId }
                realm.delete(deleteFav)
            }
        } catch {
            print("delete 실패")
        }
    }
    func filterFav(_ text: String) -> [Favorite] {
        let fav = realm.objects(Favorite.self)
            .where { favItem in
                favItem.itemName.contains(text, options: .caseInsensitive)
            }
        let result = text.isEmpty ? realm.objects(Favorite.self) : fav
        return Array(result)
    }
}
