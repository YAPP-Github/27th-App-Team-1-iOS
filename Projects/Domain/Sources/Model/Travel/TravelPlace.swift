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
    public let distanceKm: Double?
    public let transportation: [Transportation]
    public let youtubeTips: [String]
    public let planB: [PlanBInfo]
    public let estimatedDuration: Int?
    public let place: PlaceInfo

    public init(
        id: Int,
        day: Int,
        sequence: Int,
        distanceKm: Double? = nil,
        transportation: [Transportation] = [],
        youtubeTips: [String] = [],
        planB: [PlanBInfo] = [],
        estimatedDuration: Int? = nil,
        place: PlaceInfo
    ) {
        self.id = id
        self.day = day
        self.sequence = sequence
        self.distanceKm = distanceKm
        self.transportation = transportation
        self.youtubeTips = youtubeTips
        self.planB = planB
        self.estimatedDuration = estimatedDuration
        self.place = place
    }
}

/// 플랜B 정보
public struct PlanBInfo: Hashable {
    public let name: String
    public let feature: String?

    public init(name: String, feature: String? = nil) {
        self.name = name
        self.feature = feature
    }
}

/// 교통수단 정보
public struct Transportation: Hashable {
    public let mode: String
    public let timeMin: Int?

    public init(mode: String, timeMin: Int? = nil) {
        self.mode = mode
        self.timeMin = timeMin
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
    public let googleMapsUri: String

    public init(
        googlePlaceId: String,
        thumbnail: String? = nil,
        latitude: Double,
        longitude: Double,
        name: String,
        regularOpeningHours: String? = nil,
        googleMapsUri: String
    ) {
        self.googlePlaceId = googlePlaceId
        self.thumbnail = thumbnail
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.regularOpeningHours = regularOpeningHours
        self.googleMapsUri = googleMapsUri
    }
}
