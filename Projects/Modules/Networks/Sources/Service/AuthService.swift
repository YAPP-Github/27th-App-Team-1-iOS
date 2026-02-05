//
//  AuthService.swift
//  Networks
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation
import Moya

public final class AuthService: AuthServiceProtocol, @unchecked Sendable {
    private let provider: MoyaProvider<AuthAPI>

    public init(provider: MoyaProvider<AuthAPI> = MoyaProvider<AuthAPI>()) {
        self.provider = provider
    }

    public func signup(info: SignupInfo) async -> Result<SignupResult, SignupError> {
        // Domain → DTO 변환
        let request = SignupRequest(fcmToken: info.fcmToken)

        let result: NetworkResult<SignupResponse, SignupError> = await provider.request(
            .signup(request: request),
            errorMapper: SignupError.init
        )

        // NetworkResult → Result 변환 + DTO → Domain 변환
        switch result {
        case .success(let response):
            let signupResult = SignupResult(
                uuid: response.uuid,
                accessToken: response.accessToken,
                nickname: response.nickname
            )
            return .success(signupResult)
        case .failure(let error):
            return .failure(error)
        case .networkFailure(let error):
            return .failure(.networkError(message: error.message))
        }
    }
}
