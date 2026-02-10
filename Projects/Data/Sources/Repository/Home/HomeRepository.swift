//
//  HomeRepository.swift
//  Data
//
//  Created by 최안용 on 2/4/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

public final class HomeRepository: HomeRepositoryInterface {
    private let homeService: HomeServiceProtocol
    
    public init(homeService: HomeServiceProtocol) {
        self.homeService = homeService
    }
    
    public func fetchMyTripInfo() async throws -> MyTripSummary? {
        return MyTripSummary(title: "임시", startDay: .now, endDay: .now, tripSchedule: [Schedule(id: 1, day: 1, placeName: "임시", thumbnailUrl: "", transport: "", estimatedDuration: 2)])
    }
    
    public func fetchCategoryList() async throws -> [TripCategory] {
        try await homeService.getCategoryList().map { $0.toDomain() }
    }
    
    public func fetchPopularTripList(id: Int?, page: Int?, size: Int?) async throws -> [TripInfo] {
        try await homeService.getPopularTripList(id: id, page: page, size: size).toDomain()
    }
    
    public func fetchRecommendTripList(page: Int?, size: Int?) async throws -> [TripInfo] {
        try await homeService.getRecommendTripList(page: page, size: size).toDomain()
    }
}
