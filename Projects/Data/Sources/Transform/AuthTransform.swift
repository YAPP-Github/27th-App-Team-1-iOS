//
//  AuthTransform.swift
//  Data
//
//  Created by kimnahun on 2026-02-18.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Networks

extension SignupResponse {
    func toDomain() -> SignupResult {
        SignupResult(
            uuid: uuid,
            accessToken: accessToken,
            nickname: nickname
        )
    }
}

extension LoginResponse {
    func toDomain() -> LoginResult {
        LoginResult(
            uuid: uuid,
            accessToken: accessToken,
            nickname: nickname
        )
    }
}
