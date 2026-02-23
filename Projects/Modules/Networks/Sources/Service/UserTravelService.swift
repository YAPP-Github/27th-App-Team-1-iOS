//
//  UserTravelService.swift
//  Networks
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Moya

public protocol UserTravelServiceProtocol {
    func createUserTravel(request: CreateUserTravelRequest) async throws -> CreateUserTravelResponse
    func getContentCard(id: Int) async throws -> UserContentCardResponse
    func getUpcoming() async throws -> UpcomingResponse
    func getUpcomingList(page: Int?, size: Int?) async throws -> UpcomingListResponse
    func getItinerary(travelId: Int, day: Int) async throws -> UserTravelItineraryResponse
}

public final class UserTravelService: UserTravelServiceProtocol {
    private let provider: MoyaProvider<UserTravelAPI>
    
    public init(provider: MoyaProvider<UserTravelAPI> = MoyaProvider<UserTravelAPI>()) {
        self.provider = provider
    }
    
    public func createUserTravel(request: CreateUserTravelRequest) async throws -> CreateUserTravelResponse {
        try await provider.asyncThowsRequest(.createUserTravel(request: request))
    }
    
    public func getContentCard(id: Int) async throws -> UserContentCardResponse {
        try await provider.asyncThowsRequest(.getContentCard(id: id))
    }
    
    public func getUpcoming() async throws -> UpcomingResponse {
        try await provider.asyncThowsRequest(.getUpcoming)
    }
    
    public func getUpcomingList(page: Int?, size: Int?) async throws -> UpcomingListResponse {
        try await provider.asyncThowsRequest(.getUpcomingList(page: page, size: size))
    }

    public func getItinerary(travelId: Int, day: Int) async throws -> UserTravelItineraryResponse {
        try await provider.asyncThowsRequest(.getItinerary(id: travelId, day: day))
    }
}
