//
//  FollowServiceFactory.swift
//  Data
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation
import Networks

public func makeFollowService() -> FollowServiceProtocol {
    FollowService()
}
