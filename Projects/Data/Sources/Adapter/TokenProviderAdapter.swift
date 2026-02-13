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
        "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJiYmE3ODIwYS0wMDUzLTQxZDctODdhYi00Zjk2ZWM3ZDI1MTMiLCJpYXQiOjE3NzA5NjQzMDUsImV4cCI6MTc3MTA1MDcwNX0.Sn8wNhZ1Ac-ETZDsOiSMMHHaALJNXxNKrbN_-4xD5REcVa2tJ0NiafhTKlbIuYafL1Acd9dDMIHjx3H33c5w8w"
    }
}
