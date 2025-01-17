//
//  RealmRepository.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 7/8/24.
//

import Foundation

import RealmSwift

final class RealmRepository {
    
    private let realm = try! Realm()
    
    func sorting(by text: String) -> Folder? {
        let result = realm.objects(Folder.self)
            .where { $0.folderName == text }
            .first
        return result
    }
    
    func fetchFolder() -> [Folder] {
        return Array(realm.objects(Folder.self))
    }
    
    func checkFolder(with text: String) -> [Folder] {
        var folders = checkingFolder(with: text)
        let newFolder = Folder(folderName: text)
        if folders.isEmpty {
            createFolder(newFolder)
            folders = checkingFolder(with: text)
        }
        
        return folders
    }
    
    /// 검색어를 기준으로 folder의 유무 확인하여 반환
    private func checkingFolder(with text: String) -> [Folder] {
        let folders = realm.objects(Folder.self)
            .where {
                $0.folderName == text
            }
        
        return Array(folders)
    }
    /// folder 생성
    private func createFolder(_ folder: Folder) {
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
    
    // RealmStorage -> 이걸 Fav, Folder Repository에서 불러서 쓰면되는 형태.
    func update<T: Object>(value: T, _ block: @escaping (T) -> Void) throws {
        try realm.write {
            block(value)
        }
    }
    func deleteFav(_ productId: String, folder: Folder) {
        do {
            try realm.write {
                if let favIndex = folder.favs.firstIndex(where: {
                    $0.productId == productId
                }) {
                    folder.favs.remove(at: favIndex)
                }
            }
        } catch {
            print("fav 삭제 실패")
        }
    }
    
    func deleteFolder(folder: Folder) {
        do {
            try realm.write {
                realm.delete(folder)
            }
        } catch {
            print("folder 삭제 실패")
        }
    }
    
    func findFolder(favItem: Favorite) -> Folder? {
        let result = realm.objects(Folder.self)
            .where { $0.favs == favItem }
            .first
        return result
    }

    func validateFav(_ favorite: Favorite) -> Bool {
        let item = realm.object(
            ofType: Favorite.self,
            forPrimaryKey: favorite.productId
        )
        return item != nil
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
