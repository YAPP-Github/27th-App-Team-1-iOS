//
//  FollowRepositoryFactory.swift
//  Data
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation
import Networks

public func makeFollowService() -> FollowServiceProtocol {
    FollowService()
}

public func makeFollowRepository(service: FollowServiceProtocol) -> FollowRepositoryProtocol {
    FollowRepository(service: service)
}
