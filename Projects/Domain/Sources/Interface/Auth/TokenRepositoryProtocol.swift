//
//  TokenRepositoryProtocol.swift
//  Domain
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public enum TokenType: String, CaseIterable {
    case uuid
    case accessToken
    case fcmToken
}

public protocol TokenRepositoryProtocol {
    func save(_ value: String, for type: TokenType)
    func get(_ type: TokenType) -> String?
    func delete(_ type: TokenType)
}
