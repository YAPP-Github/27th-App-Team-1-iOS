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
    public let thumbnail: String?
    public let latitude: Double
    public let longitude: Double
    public let name: String
    public let regularOpeningHours: String?

    public init(
        googlePlaceId: String,
        thumbnail: String? = nil,
        latitude: Double,
        longitude: Double,
        name: String,
        regularOpeningHours: String?
    ) {
        self.googlePlaceId = googlePlaceId
        self.thumbnail = thumbnail
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.regularOpeningHours = regularOpeningHours
    }
}
