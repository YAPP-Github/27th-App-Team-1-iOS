//
//  UserDefaultWrapper.swift
//  Core
//
//  Created by 최안용 on 2/23/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

@propertyWrapper public struct UserDefaultWrapper<T> {
    public var wrappedValue: T? {
        get {
            return UserDefaults.standard.object(forKey: self.key.rawValue) as? T
        }
        
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: self.key.rawValue)
            } else {
                UserDefaults.standard.setValue(newValue, forKey: self.key.rawValue)
            }
        }
    }
    
    private let key: UserDefaultKeys
    
    public init(key: UserDefaultKeys) {
        self.key = key
    }
}
