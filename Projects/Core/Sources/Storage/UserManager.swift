//
//  UserManager.swift
//  Core
//
//  Created by 최안용 on 2/23/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public enum UserDefaultKeys: String {
    case uuid = "uuid"
    case nickname = "nickname"
    case isFirstOpen = "isFirstOpen"
}

public final class UserManager {
    @UserDefaultWrapper(key: .uuid) public var uuid: String?
    @UserDefaultWrapper(key: .nickname) public var nickname: String?
    @UserDefaultWrapper(key: .isFirstOpen) private var isFirstOpen: Bool?
    
    public static let shared = UserManager()
    
    private init() {}
    
    public func isFirstOpenApp() -> Bool {
        guard let isFirstOpen else {
            self.isFirstOpen = true
            return true
        }
        return !isFirstOpen
    }
}
