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

    public func fetchTravelDetail(id: Int) async -> Result<TravelDetail, ContentCardError> {
        let result: NetworkResult<FollowContentCardResponse, ContentCardError> = await provider.request(
            .getContentCard(id: id),
            errorMapper: ContentCardError.init
        )

        switch result {
        case .success(let response):
            return .success(response.toDomain())
        case .failure(let error):
            return .failure(error)
        case .networkFailure(let error):
            return .failure(.unknown(code: "NETWORK", message: error.message))
        }
    }

    public func fetchPlaces(travelId: Int, day: Int) async -> Result<[TravelPlace], ItineraryError> {
        let result: NetworkResult<FollowItineraryResponse, ItineraryError> = await provider.request(
            .getItinerary(id: travelId, day: day),
            errorMapper: ItineraryError.init
        )

        switch result {
        case .success(let response):
            return .success(response.toDomain())
        case .failure(let error):
            return .failure(error)
        case .networkFailure(let error):
            return .failure(.unknown(code: "NETWORK", message: error.message))
        }
    }

    public func fetchPlaceDetail(googlePlaceId: String) async -> Result<PlaceDetail, PlaceDetailError> {
        let result: NetworkResult<PlaceDetailResponse, PlaceDetailError> = await provider.request(
            .getPlaceDetail(googlePlaceId: googlePlaceId),
            errorMapper: PlaceDetailError.init
        )

        switch result {
        case .success(let response):
            return .success(response.toDomain())
        case .failure(let error):
            return .failure(error)
        case .networkFailure(let error):
            return .failure(.unknown(code: "NETWORK", message: error.message))
        }
    }

    public func fetchPlacePhotos(googlePlaceId: String) async -> Result<[PlacePhoto], PlacePhotosError> {
        let result: NetworkResult<PlacePhotosResponse, PlacePhotosError> = await provider.request(
            .getPlacePhotos(googlePlaceId: googlePlaceId),
            errorMapper: PlacePhotosError.init
        )

        switch result {
        case .success(let response):
            return .success(response.toDomain())
        case .failure(let error):
            return .failure(error)
        case .networkFailure(let error):
            return .failure(.unknown(code: "NETWORK", message: error.message))
        }
    }
}
