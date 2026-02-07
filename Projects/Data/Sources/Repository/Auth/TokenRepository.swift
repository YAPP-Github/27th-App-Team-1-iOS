//
//  TokenRepository.swift
//  Data
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Core
import Domain
import Foundation

public final class TokenRepository: TokenRepositoryProtocol {

    // MARK: - Properties

    private let keychainStorage: KeychainStorageProtocol

    // MARK: - Initialization

    public init(keychainStorage: KeychainStorageProtocol) {
        self.keychainStorage = keychainStorage
    }

    // MARK: - TokenRepositoryProtocol

    public func save(_ value: String, for type: TokenType) {
        keychainStorage.save(value, forKey: type.rawValue)
    }

    public func get(_ type: TokenType) -> String? {
        keychainStorage.load(forKey: type.rawValue)
    }

    public func delete(_ type: TokenType) {
        keychainStorage.delete(forKey: type.rawValue)
    }
}
