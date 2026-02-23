//
//  FollowDetailUsecase.swift
//  Domain
//
//  Created by 최안용 on 2/16/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public protocol FollowDetailUsecaseProtocol {
    func fetchTravelDetail(id: Int) async throws -> TravelDetail
    func fetchPlaces(travelId: Int, day: Int) async throws -> [TravelPlace]
    func fetchMyTravelDetail(id: Int) async throws -> TravelDetail
    func fetchMyTravelPlaces(travelId: Int, day: Int) async throws -> [TravelPlace]
    func createUserTravel(request: CreateTravelRequest) async throws -> CreateTravelResponse
    func fetchPlaceDetail(googlePlaceId: String) async throws -> PlaceDetail
    func fetchPlacePhotos(googlePlaceId: String) async throws -> [PlacePhoto]
    func searchPlaces(keyword: String) async throws -> [PlaceSearchResult]
}

public final class FollowDetailUsecase {
    private let travelTemplateRepository: TravelTemplateRepositoryInterface
    private let userTravelRepository: UserTravelRepositoryInterface
    private let placeRepository: PlaceRepositoryInterface
    
    public init(
        travelTemplateRepository: TravelTemplateRepositoryInterface,
        userTravelRepository: UserTravelRepositoryInterface,
        placeRepository: PlaceRepositoryInterface
    ) {
        self.travelTemplateRepository = travelTemplateRepository
        self.userTravelRepository = userTravelRepository
        self.placeRepository = placeRepository
    }
}

extension FollowDetailUsecase: FollowDetailUsecaseProtocol {
    public func fetchTravelDetail(id: Int) async throws -> TravelDetail {
        try await travelTemplateRepository.fetchTravelDetail(id: id)
    }
    
    public func fetchPlaces(travelId: Int, day: Int) async throws -> [TravelPlace] {
        try await travelTemplateRepository.fetchPlaces(travelId: travelId, day: day)
    }

    public func fetchMyTravelDetail(id: Int) async throws -> TravelDetail {
        try await userTravelRepository.fetchUserTravelDetail(id: id)
    }

    public func fetchMyTravelPlaces(travelId: Int, day: Int) async throws -> [TravelPlace] {
        try await userTravelRepository.fetchItinerary(travelId: travelId, day: day)
    }
    
    public func createUserTravel(request: CreateTravelRequest) async throws -> CreateTravelResponse {
        try await userTravelRepository.createUserTravel(request: request)
    }
    
    public func fetchPlaceDetail(googlePlaceId: String) async throws -> PlaceDetail {
        try await placeRepository.fetchPlaceDetail(googlePlaceId: googlePlaceId)
    }
    
    public func fetchPlacePhotos(googlePlaceId: String) async throws -> [PlacePhoto] {
        try await placeRepository.fetchPlacePhotos(googlePlaceId: googlePlaceId)
    }

    public func searchPlaces(keyword: String) async throws -> [PlaceSearchResult] {
        try await placeRepository.searchPlaces(keyword: keyword)
    }
}
