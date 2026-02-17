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
        "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJiYmE3ODIwYS0wMDUzLTQxZDctODdhYi00Zjk2ZWM3ZDI1MTMiLCJpYXQiOjE3NzEyMzU1MDUsImV4cCI6MTc3MTMyMTkwNX0.SfuVfF9FFpnFcUkGM7zC7mlE7-f8zo3NgG5mm86xekLnurFhGgnTIhwpew7FinguOex0smsnx--EHsMaED8D5A"
    }
}
