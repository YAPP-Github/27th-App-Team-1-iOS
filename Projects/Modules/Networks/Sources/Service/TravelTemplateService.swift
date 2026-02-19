//
//  TravelTemplateService.swift
//  Networks
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Moya

public protocol TravelTemplateServiceProtocol {
    func getItinerary(travelId: Int, day: Int) async throws -> FollowItineraryResponse
    func getContentCard(id: Int) async throws -> FollowContentCardResponse
    func searchTemplate(keyword: String, page: Int?, size: Int?) async throws -> TripResponse
    func getPopularTripList(id: Int?, page: Int?, size: Int?) async throws -> TripResponse
    func getRecommendTripList(page: Int?, size: Int?) async throws -> TripResponse
}

public final class TravelTemplateService: TravelTemplateServiceProtocol {
    private let provider: MoyaProvider<TravelTemplateAPI>
    
    public init(provider: MoyaProvider<TravelTemplateAPI> = MoyaProvider<TravelTemplateAPI>()) {
        self.provider = provider
    }
    
    public func getItinerary(travelId: Int, day: Int) async throws -> FollowItineraryResponse {
        try await provider.asyncThowsRequest(.getItinerary(id: travelId, day: day))
    }
    
    public func getContentCard(id: Int) async throws -> FollowContentCardResponse {
        try await provider.asyncThowsRequest(.getContentCard(id: id))
    }
    
    public func searchTemplate(keyword: String, page: Int?, size: Int?) async throws -> TripResponse {
        try await provider.asyncThowsRequest(.searchTemplate(keyword: keyword, page: page, size: size))
    }
    
    public func getPopularTripList(id: Int?, page: Int?, size: Int?) async throws -> TripResponse {
        try await provider.asyncThowsRequest(.getPopularTripList(id: id, page: page, size: size))
    }
    
    public func getRecommendTripList(page: Int?, size: Int?) async throws -> TripResponse {
        try await provider.asyncThowsRequest(.getRecommendTripList(page: page, size: size))
    }
}
