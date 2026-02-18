//
//  TokenProviderAdapter.swift
//  Data
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation

public final class TokenProviderAdapter: TokenProviding, @unchecked Sendable {

    private let tokenRepository: TokenRepositoryProtocol

    public init(tokenRepository: TokenRepositoryProtocol) {
        self.tokenRepository = tokenRepository
    }

    public func accessToken() -> String? {
        tokenRepository.get(.accessToken)
    }
}
