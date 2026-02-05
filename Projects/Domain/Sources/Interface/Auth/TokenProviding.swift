//
//  TokenProviding.swift
//  Domain
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public protocol TokenProviding: Sendable {
    func accessToken() -> String?
}
