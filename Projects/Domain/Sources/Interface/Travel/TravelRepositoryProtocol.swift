//
//  TravelRepositoryProtocol.swift
//  Domain
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public protocol TravelRepositoryProtocol: Sendable {
    /// 내가 등록한 여행지 목록 조회
    func fetchMyTrips() async -> [MyTrip]

    /// 인기 여행 따라가기 목록 조회
    func fetchPopularTrips(category: TripCategory) async -> [PopularTrip]

    /// 추천 따라하기 콘텐츠 목록 조회
    func fetchRecommendations() async -> [Recommendation]
}
