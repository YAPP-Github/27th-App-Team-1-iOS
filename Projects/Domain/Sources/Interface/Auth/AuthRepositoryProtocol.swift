//
//  AuthRepositoryProtocol.swift
//  Domain
//
//  Created by kimnahun on 1/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public protocol AuthRepositoryProtocol: Sendable {
    func signup(info: SignupInfo) async -> Result<SignupResult, SignupError>
}
