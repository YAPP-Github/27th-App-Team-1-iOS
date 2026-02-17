//
//  TravelTemplateServiceFactory.swift
//  Data
//
//  Created by 최안용 on 2/15/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

import Moya

public func makeTravelTemplateService(tokenProvider: TokenProviding) -> TravelTemplateServiceProtocol {
    let provider: MoyaProvider<TravelTemplateAPI> = NetworkProviderFactory.makeAuthenticatedProvider(tokenProvider: tokenProvider)
    
    return TravelTemplateService(provider: provider)
}
