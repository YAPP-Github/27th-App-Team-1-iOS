//
//  FollowService.swift
//  Networks
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation
import Moya

public protocol FollowServiceProtocol: Sendable {
    /// 여행 템플릿 상세 조회
    func getContentCard(id: Int) async -> NetworkResult<FollowContentCardResponse, FollowError>
    /// 여행 템플릿 일정 조회
    func getItinerary(id: Int, day: Int?) async -> NetworkResult<FollowItineraryResponse, FollowError>
}

public final class FollowService: FollowServiceProtocol, @unchecked Sendable {
    private let provider: MoyaProvider<FollowAPI>

    public init(provider: MoyaProvider<FollowAPI> = MoyaProvider<FollowAPI>()) {
        self.provider = provider
    }

    public func getContentCard(id: Int) async -> NetworkResult<FollowContentCardResponse, FollowError> {
        await provider.request(.getContentCard(id: id), errorMapper: FollowError.init)
    }

    public func getItinerary(id: Int, day: Int?) async -> NetworkResult<FollowItineraryResponse, FollowError> {
        await provider.request(.getItinerary(id: id, day: day), errorMapper: FollowError.init)
    }
}
