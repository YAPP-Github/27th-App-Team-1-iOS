//
//  AuthRepository.swift
//  Data
//
//  Created by kimnahun on 2026-02-18.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

public final class AuthRepository: AuthRepositoryInterface {
    private let service: AuthServiceProtocol

    public init(service: AuthServiceProtocol) {
        self.service = service
    }

    public func signup(info: SignupInfo) async throws -> SignupResult {
        do {
            let request = SignupRequest(fcmToken: info.fcmToken)
            return try await service.signup(request: request).toDomain()
        } catch {
            throw error.toNDGLError()
        }
    }

    public func login(uuid: String) async throws -> LoginResult {
        do {
            let request = LoginRequest(uuid: uuid)
            return try await service.login(request: request).toDomain()
        } catch {
            throw error.toNDGLError()
        }
    }
}
