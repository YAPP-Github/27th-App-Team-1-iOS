//
//  TravelPlace.swift
//  Domain
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

/// 여행 장소 정보
public struct TravelPlace: Hashable {
    public let id: Int
    public let day: Int
    public let sequence: Int
    public let travelerTip: String
    public let estimatedDuration: Int
    public let place: PlaceInfo

    public init(
        id: Int,
        day: Int,
        sequence: Int,
        travelerTip: String,
        estimatedDuration: Int,
        place: PlaceInfo
    ) {
        self.id = id
        self.day = day
        self.sequence = sequence
        self.travelerTip = travelerTip
        self.estimatedDuration = estimatedDuration
        self.place = place
    }
}

/// 장소 상세 정보
public struct PlaceInfo: Hashable {
    public let googlePlaceId: String
    public let latitude: Double
    public let longitude: Double
    public let name: String
    public let regularOpeningHours: String?
    public let category: PlaceCategory

    public init(
        googlePlaceId: String,
        latitude: Double,
        longitude: Double,
        name: String,
        regularOpeningHours: String?,
        category: PlaceCategory = .etc
    ) {
        self.googlePlaceId = googlePlaceId
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.regularOpeningHours = regularOpeningHours
        self.category = category
    }
}

/// 장소 카테고리
public enum PlaceCategory: String, Hashable {
    case transportation = "교통수단"
    case tourism = "관광명소"
    case restaurant = "음식점"
    case cafe = "카페"
    case accommodation = "숙소"
    case etc = "기타"
}
