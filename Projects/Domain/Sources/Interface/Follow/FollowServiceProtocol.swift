//
//  FollowServiceProtocol.swift
//  Domain
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public protocol FollowServiceProtocol: Sendable {
    /// 여행 상세 정보 조회
    func fetchTravelDetail(id: Int) async -> Result<TravelDetail, FollowError>

    /// 일차별 장소 목록 조회
    func fetchPlaces(travelId: Int, day: Int) async -> Result<[TravelPlace], FollowError>
}
