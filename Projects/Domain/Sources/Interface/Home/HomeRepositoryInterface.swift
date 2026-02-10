//
//  HomeRepositoryInterface.swift
//  Domain
//
//  Created by 최안용 on 2/4/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

// MARK: - API 나오기 전 임시
public protocol HomeRepositoryInterface {
    func fetchMyTripInfo() async throws -> MyTripSummary?
    func fetchCategoryList() async throws -> [TripCategory]
    func fetchPopularTripList(id: Int?, page: Int?, size: Int?) async throws -> [TripInfo]
    func fetchRecommendTripList(page: Int?, size: Int?) async throws -> [TripInfo]
}
