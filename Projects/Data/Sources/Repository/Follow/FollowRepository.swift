//
//  FollowRepository.swift
//  Data
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation
import Networks

public final class FollowRepository: FollowRepositoryProtocol, @unchecked Sendable {
    private let service: FollowServiceProtocol

    public init(service: FollowServiceProtocol) {
        self.service = service
    }

    public func fetchTravelDetail(id: Int) async -> TravelDetail? {
        let result = await service.getContentCard(id: id)

        switch result {
        case .success(let response):
            return response.toDomain()
        case .failure, .networkFailure:
            return nil
        }
    }

    public func fetchPlaces(travelId: Int, day: Int) async -> [TravelPlace] {
        let result = await service.getItinerary(id: travelId, day: day)

        switch result {
        case .success(let response):
            return response.toDomain()
        case .failure, .networkFailure:
            return []
        }
    }
}
