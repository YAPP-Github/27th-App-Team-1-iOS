//
//  UserTravelServiceFactory.swift
//  Data
//
//  Created by 최안용 on 2/15/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

import Moya

public func makeUserTravelService(tokenProvider: TokenProviding) -> UserTravelServiceProtocol {
    let provider: MoyaProvider<UserTravelAPI> = NetworkProviderFactory.makeAuthenticatedProvider(tokenProvider: tokenProvider)
    
    return UserTravelService(provider: provider)
}
