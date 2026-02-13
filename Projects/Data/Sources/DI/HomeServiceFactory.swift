//
//  HomeServiceFactory.swift
//  Data
//
//  Created by 최안용 on 2/10/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Networks

import Moya

public func makeHomeService(tokenProvider: TokenProviding) -> HomeServiceProtocol {
    let provider: MoyaProvider<HomeAPI> = NetworkProviderFactory.makeAuthenticatedProvider(tokenProvider: tokenProvider)
    return HomeService(provider: provider)
}
