//
//  SignupResult.swift
//  Domain
//
//  Created by kimnahun on 1/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct SignupResult: Sendable {
    public let uuid: String
    public let accessToken: String
    public let nickname: String

    public init(uuid: String, accessToken: String, nickname: String) {
        self.uuid = uuid
        self.accessToken = accessToken
        self.nickname = nickname
    }
}
