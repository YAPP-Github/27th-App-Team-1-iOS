//
//  AuthServiceFactory.swift
//  Data
//
//  Created by kimnahun on 1/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation
import Networks

public func makeAuthService() -> AuthServiceProtocol {
    AuthService()
}
