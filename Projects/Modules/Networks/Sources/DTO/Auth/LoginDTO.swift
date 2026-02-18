//
//  LoginDTO.swift
//  Networks
//
//  Created by kimnahun on 2026-02-18.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct LoginRequest: Encodable, Sendable {
    public let uuid: String

    public init(uuid: String) {
        self.uuid = uuid
    }
}

public struct LoginResponse: Decodable, Sendable {
    public let uuid: String
    public let accessToken: String
    public let nickname: String
}
