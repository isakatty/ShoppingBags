//
//  UserDefaultsManager.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

public final class UserDefaultsManager {
    public static let shared = UserDefaultsManager()

    private init() {
        
    }
    public func saveValue<T>(
        _ value: T,
        forKey key: SaveData
    ) {
        UserDefaults.standard.setValue(
            value,
            forKey: key.rawValue
        )
    }
    public func getValue<T>(forKey key: SaveData) -> T? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? T
    }

    public func removeValue(forKey key: SaveData) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
