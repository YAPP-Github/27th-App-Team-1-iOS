//
//  AuthService.swift
//  Networks
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import Moya

public protocol AuthServiceProtocol: Sendable {
    func signup(request: SignupRequest) async throws -> SignupResponse
    func login(request: LoginRequest) async throws -> LoginResponse
}

public final class AuthService: AuthServiceProtocol, @unchecked Sendable {
    private let provider: MoyaProvider<AuthAPI>

    public init(provider: MoyaProvider<AuthAPI> = MoyaProvider<AuthAPI>()) {
        self.provider = provider
    }

    public func signup(request: SignupRequest) async throws -> SignupResponse {
        try await provider.asyncThowsRequest(.signup(request: request))
    }

    public func login(request: LoginRequest) async throws -> LoginResponse {
        try await provider.asyncThowsRequest(.login(request: request))
    }
}
