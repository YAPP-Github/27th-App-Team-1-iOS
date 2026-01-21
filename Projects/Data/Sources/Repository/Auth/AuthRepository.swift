//
//  AuthRepository.swift
//  Data
//
//  Created by kimnahun on 1/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation
import Networks

public final class AuthRepository: AuthRepositoryProtocol, @unchecked Sendable {
    private let authService: AuthServiceProtocol

    public init(authService: AuthServiceProtocol) {
        self.authService = authService
    }

    public func signup(info: SignupInfo) async -> Result<SignupResult, SignupError> {
        let request = SignupRequest(fcmToken: info.fcmToken)
        let result = await authService.signup(request: request)

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

        case .networkFailure(let networkError):
            return .failure(.networkError(message: networkError.localizedDescription))
        }
    }
}
