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
    func fetchTravelDetail(id: Int) async -> Result<TravelDetail, ContentCardError>

    /// 일차별 장소 목록 조회
    func fetchPlaces(travelId: Int, day: Int) async -> Result<[TravelPlace], ItineraryError>

    /// 장소 상세 조회
    func fetchPlaceDetail(googlePlaceId: String) async -> Result<PlaceDetail, PlaceDetailError>

    /// 장소 사진 조회
    func fetchPlacePhotos(googlePlaceId: String) async -> Result<[PlacePhoto], PlacePhotosError>
}
