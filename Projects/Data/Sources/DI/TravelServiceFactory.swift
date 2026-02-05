//
//  TravelServiceFactory.swift
//  Data
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation
import Moya
import Networks

public func makeTravelService(tokenProvider: TokenProviding) -> TravelServiceProtocol {
    let provider: MoyaProvider<TravelAPI> = NetworkProviderFactory.makeAuthenticatedProvider(
        tokenProvider: tokenProvider
    )
    return TravelService(provider: provider)
}
