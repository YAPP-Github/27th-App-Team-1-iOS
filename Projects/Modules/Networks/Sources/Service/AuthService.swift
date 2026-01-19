//
//  AuthService.swift
//  Networks
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import Moya

public protocol AuthServiceProtocol {
    func signup(request: SignupRequest) async -> NetworkResult<SignupResponse, SignupError>
}

public final class AuthService: AuthServiceProtocol {
    private let provider: MoyaProvider<AuthAPI>

    public init(provider: MoyaProvider<AuthAPI> = MoyaProvider<AuthAPI>()) {
        self.provider = provider
    }

    public func signup(request: SignupRequest) async -> NetworkResult<SignupResponse, SignupError> {
        await provider.request(.signup(request: request), errorType: SignupError.self)
    }
}
