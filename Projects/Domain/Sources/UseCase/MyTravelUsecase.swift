//
//  MyTravelUsecase.swift
//  Domain
//
//  Created by 최안용 on 2/22/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public protocol MyTravelUsecaseProtocol {
    func fetchMyTripInfo() async throws -> MyTripSummary
    func fetchUpcomingList(page: Int?, size: Int?) async throws -> [UpcomingInfo]
    func fetchRecommendTripList(page: Int?, size: Int?) async throws -> [TripInfo]
}

public extension MyTravelUsecaseProtocol {
    func fetchUpcomingList(
        page: Int? = nil,
        size: Int? = nil
    ) async throws -> [UpcomingInfo] {
        try await fetchUpcomingList(page: page, size: size)
    }
    
    func fetchRecommendTripList(
        page: Int? = nil,
        size: Int? = nil
    ) async throws -> [TripInfo] {
        try await fetchRecommendTripList(page: page, size: size)
    }
}

public final class MyTravelUsecase {
    private let travelTemplateRepository: TravelTemplateRepositoryInterface
    private let userTravelRepository: UserTravelRepositoryInterface
    
    public init(
        travelTemplateRepository: TravelTemplateRepositoryInterface,
        userTravelRepository: UserTravelRepositoryInterface
    ) {
        self.travelTemplateRepository = travelTemplateRepository
        self.userTravelRepository = userTravelRepository
    }
}

extension MyTravelUsecase: MyTravelUsecaseProtocol {
    public func fetchMyTripInfo() async throws -> MyTripSummary {
        try await userTravelRepository.fetchUpcoming()
    }
    
    public func fetchUpcomingList(page: Int?, size: Int?) async throws -> [UpcomingInfo] {
        try await userTravelRepository.fetchUpcomingList(page: page, size: size)
    }
    
    public func fetchRecommendTripList(page: Int?, size: Int?) async throws -> [TripInfo] {
        try await travelTemplateRepository.fetchRecommendTripList(page: page, size: size)
    }
}
