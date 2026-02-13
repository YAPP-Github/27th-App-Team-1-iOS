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
    private let repository: HomeRepositoryInterface
    
    public init(repository: HomeRepositoryInterface) {
        self.repository = repository
    }
}

extension HomeUsecase: HomeUsecaseProtocol {
    public func fetchMyTripInfo() async throws -> MyTripSummary {
        try await repository.fetchMyTripInfo()
    }
    
    public func fetchCategoryList() async throws -> [TripCategory] {
        try await repository.fetchCategoryList()
    }
    
    public func fetchPopularTripList(id: Int?, page: Int?, size: Int?) async throws -> [TripInfo] {
        try await repository.fetchPopularTripList(id: id, page: page, size: size)
    }
    
    public func fetchRecommendTripList(page: Int?, size: Int?) async throws -> [TripInfo] {
        try await repository.fetchRecommendTripList(page: page, size: size)
    }
}
