//
//  AuthPlugin.swift
//  Networks
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation
import Moya

public final class AuthPlugin: PluginType, @unchecked Sendable {

    private let tokenProvider: TokenProviding

    public init(tokenProvider: TokenProviding) {
        self.tokenProvider = tokenProvider
    }

    public func prepare(_ request: URLRequest, target: any TargetType) -> URLRequest {
        var request = request

        if let token = tokenProvider.accessToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
}
