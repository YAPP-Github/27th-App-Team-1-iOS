//
//  TokenRepositoryFactory.swift
//  Data
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Core
import Domain
import Foundation

public enum TokenRepositoryFactory {

    public static func make() -> TokenRepositoryProtocol {
        let keychainStorage = KeychainStorage()
        return TokenRepository(keychainStorage: keychainStorage)
    }

    public static func makeTokenProvider() -> TokenProviding {
        let tokenRepository = make()
        return TokenProviderAdapter(tokenRepository: tokenRepository)
    }

    public static func makeTokenProvider(with repository: TokenRepositoryProtocol) -> TokenProviding {
        TokenProviderAdapter(tokenRepository: repository)
    }
}
