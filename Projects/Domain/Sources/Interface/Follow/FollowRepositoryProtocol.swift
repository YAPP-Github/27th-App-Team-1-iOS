//
//  FollowRepositoryProtocol.swift
//  Domain
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public protocol FollowRepositoryProtocol {
    /// 여행 상세 정보 조회
    func fetchTravelDetail(id: Int) async -> TravelDetail?

    /// 일차별 장소 목록 조회
    func fetchPlaces(travelId: Int, day: Int) async -> [TravelPlace]
}
