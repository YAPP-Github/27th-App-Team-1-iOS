//
//  HomeUsecase.swift
//  Domain
//
//  Created by 최안용 on 2/4/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

// MARK: - API 나오기 전 임시
public protocol HomeUsecaseProtocol {
    func fetchMyTripInfo() async throws -> MyTripSummary
    func fetchCategoryList() async throws -> [TripCategory]
    func fetchPopularTripList(id: Int?, page: Int?, size: Int?) async throws -> [TripInfo]
    func fetchRecommendTripList(page: Int?, size: Int?) async throws -> [TripInfo]
}

public extension HomeUsecaseProtocol {
    func fetchPopularTripList(
        id: Int? = nil,
        page: Int? = nil,
        size: Int? = nil
    ) async throws -> [TripInfo] {
        try await fetchPopularTripList(id: id, page: page, size: size)
    }
    
    func fetchRecommendTripList(
        page: Int? = nil,
        size: Int? = nil
    ) async throws -> [TripInfo] {
        try await fetchRecommendTripList(page: page, size: size)
    }
}

public final class HomeUsecase {
    private let travelTemplateRepository: TravelTemplateRepositoryInterface
    private let travelRepository: TravelProgramRepositoryInterface
    private let userTravelRepository: UserTravelRepositoryInterface
    
    public init(
        travelTemplateRepository: TravelTemplateRepositoryInterface,
        travelRepository: TravelProgramRepositoryInterface,
        userTravelRepository: UserTravelRepositoryInterface
    ) {
        self.travelTemplateRepository = travelTemplateRepository
        self.travelRepository = travelRepository
        self.userTravelRepository = userTravelRepository
    }
}

extension HomeUsecase: HomeUsecaseProtocol {
    public func fetchMyTripInfo() async throws -> MyTripSummary {
        try await userTravelRepository.fetchUpcoming()
    }
    
    public func fetchCategoryList() async throws -> [TripCategory] {
        try await travelRepository.fetchCategoryList()
    }
    
    public func fetchPopularTripList(id: Int?, page: Int?, size: Int?) async throws -> [TripInfo] {
        try await travelTemplateRepository.fetchPopularTripList(id: id, page: page, size: size)
    }
    
    public func fetchRecommendTripList(page: Int?, size: Int?) async throws -> [TripInfo] {
        try await travelTemplateRepository.fetchRecommendTripList(page: page, size: size)
    }
}
