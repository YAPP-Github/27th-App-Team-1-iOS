//
//  AuthRepositoryInterface.swift
//  Domain
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public protocol AuthRepositoryInterface {
    func signup(info: SignupInfo) async throws -> SignupResult
    func login(uuid: String) async throws -> LoginResult
}
