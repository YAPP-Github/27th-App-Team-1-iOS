//
//  HomeServiceProtocol.swift
//  Domain
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

//import Foundation
//
//public protocol HomeServiceProtocol: Sendable {
//    /// 내가 등록한 여행지 목록 조회
//    func fetchMyTrips() async -> Result<[MyTrip], HomeError>
//
//    /// 인기 여행 따라가기 목록 조회 (단일 카테고리)
//    func fetchPopularTrips(category: TripCategory) async -> Result<[PopularTrip], HomeError>
//
//    /// 인기 여행 따라가기 전체 조회 (모든 카테고리별로 그룹화)
//    func fetchAllPopularTrips() async -> Result<[TripCategory: [PopularTrip]], HomeError>
//
//    /// 추천 따라하기 콘텐츠 목록 조회
//    func fetchRecommendations() async -> Result<[Recommendation], HomeError>
//}
