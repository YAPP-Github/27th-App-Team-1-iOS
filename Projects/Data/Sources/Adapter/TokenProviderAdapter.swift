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
//        tokenRepository.get(.accessToken)
        "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJiYmE3ODIwYS0wMDUzLTQxZDctODdhYi00Zjk2ZWM3ZDI1MTMiLCJpYXQiOjE3NzA3OTUwMjYsImV4cCI6MTc3MDg4MTQyNn0.oNCkotV0uA-3kCtTwGhTUwA9fUUhuO85p1k3952oTfRaULOw2Ix3RpXq_ta82ynmUK7F3i8F0Jb1d4_Rl-zcgA"
    }
}
