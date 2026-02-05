//
//  NetworkProviderFactory.swift
//  Networks
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation
import Moya

public enum NetworkProviderFactory {

    public static func makeProvider<T: TargetType>(
        tokenProvider: TokenProviding? = nil,
        plugins: [PluginType] = []
    ) -> MoyaProvider<T> {
        var allPlugins = plugins

        if let tokenProvider = tokenProvider {
            allPlugins.append(AuthPlugin(tokenProvider: tokenProvider))
        }

        return MoyaProvider<T>(plugins: allPlugins)
    }

    public static func makeAuthenticatedProvider<T: TargetType>(
        tokenProvider: TokenProviding,
        plugins: [PluginType] = []
    ) -> MoyaProvider<T> {
        makeProvider(tokenProvider: tokenProvider, plugins: plugins)
    }
}
