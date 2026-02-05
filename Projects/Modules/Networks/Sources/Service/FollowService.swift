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

public final class FollowService: FollowServiceProtocol, @unchecked Sendable {
    private let provider: MoyaProvider<FollowAPI>

    public init(provider: MoyaProvider<FollowAPI> = MoyaProvider<FollowAPI>()) {
        self.provider = provider
    }

    public func fetchTravelDetail(id: Int) async -> Result<TravelDetail, FollowError> {
        let result: NetworkResult<FollowContentCardResponse, FollowError> = await provider.request(
            .getContentCard(id: id),
            errorMapper: FollowError.init
        )

        switch result {
        case .success(let response):
            return .success(response.toDomain())
        case .failure(let error):
            return .failure(error)
        case .networkFailure(let error):
            return .failure(.networkError(message: error.message))
        }
    }

    public func fetchPlaces(travelId: Int, day: Int) async -> Result<[TravelPlace], FollowError> {
        let result: NetworkResult<FollowItineraryResponse, FollowError> = await provider.request(
            .getItinerary(id: travelId, day: day),
            errorMapper: FollowError.init
        )

        switch result {
        case .success(let response):
            return .success(response.toDomain())
        case .failure(let error):
            return .failure(error)
        case .networkFailure(let error):
            return .failure(.networkError(message: error.message))
        }
    }
}
