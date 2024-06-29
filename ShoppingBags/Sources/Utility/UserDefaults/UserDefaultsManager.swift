//
//  UserDefaultsManager.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private init() {
        
    }
    func saveValue<T>(
        _ value: T,
        forKey key: SaveData
    ) {
        UserDefaults.standard.setValue(
            value,
            forKey: key.rawValue
        )
    }
    func getValue<T>(forKey key: SaveData) -> T? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? T
    }

    func removeValue(forKey key: SaveData) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
/*
@propertyWrapper
struct UserDefault<T> {
    let key: SaveData
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaultsManager.shared
                .getValue(forKey: key) ?? self.defaultValue
        }
        set {
            UserDefaultsManager.shared.saveValue(
                newValue,
                forKey: key
            )
        }
    }
}

final class UserManager {
    static let shared = UserManager()
    
    private init() { }
    
    @UserDefault(
        key: SaveData.signupDate,
        defaultValue: nil
    )
    var signUpDate: String?
    
    @UserDefault(
        key: SaveData.nickname,
        defaultValue: ""
    )
    var nickname: String
    
    @UserDefault(
        key: SaveData.profileImgTitle,
        defaultValue: "profile_" + "\(Int.random(in: 0...11))"
    )
    var profileImgName: String
    
    @UserDefault(key: SaveData.searchedText, defaultValue: [""])
    var searchedText: [String]
    
    @UserDefault(key: SaveData.shoppingBags, defaultValue: [""])
    var shoppingBags: [String]
    
    
    func removeAllData() {
        
    }
}
*/
