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
    
    // TODO: 검색어를 기준으로 folder가 있는지 없는지 확인하고, 없을시 folder 생성 및 folder에 data 추가
    func checkFolder(with text: String, fav: Favorite) {
        var folders = checkingFolder(with: text)
        let newFolder = Folder(folderName: text)
        if folders.isEmpty {
            createFolder(newFolder)
            folders = checkingFolder(with: text)
        }
        
        if let folder = folders.first {
            createFav(fav, folder: folder)
        }
    }
    
    /// 검색어를 기준으로 folder의 유무 확인하여 반환
    func checkingFolder(with text: String) -> [Folder] {
        let folders = realm.objects(Folder.self)
            .where {
                $0.folderName == text
            }
        
        return Array(folders)
    }
    /// folder 생성
    func createFolder(_ folder: Folder) {
        do {
            try realm.write {
                realm.add(folder)
            }
        } catch {
            print("Folder 생성 실패")
        }
    }
    
    /// favorite 저장
    func createFav(_ favItem: Favorite, folder: Folder) {
        do {
            try realm.write {
                folder.favs.append(favItem)
            }
        } catch {
            print("데이터 append 실패")
        }
    }
    
    // ---------------------------------------
    
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
