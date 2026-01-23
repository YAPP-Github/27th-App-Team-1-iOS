//
//  FollowTransform.swift
//  Data
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation
import Networks

// MARK: - ContentCard Response to TravelDetail

extension FollowContentCardResponse {
    func toDomain() -> TravelDetail {
        TravelDetail(
            travelId: travelId,
            country: country,
            city: city,
            budgetPerPerson: budgetPerPerson,
            nights: nights,
            days: days,
            youtube: youtube.toDomain()
        )
    }
}

extension YouTubeResponse {
    func toDomain() -> YouTubeInfo {
        YouTubeInfo(
            title: title,
            youtuber: name,
            thumbnail: thumbnail,
            profileImage: profileImage,
            link: link,
            summary: summary
        )
    }
}

// MARK: - Itinerary Response to TravelPlace

extension FollowItineraryResponse {
    func toDomain() -> [TravelPlace] {
        places.map { $0.toDomain() }
    }
}

extension FollowPlaceResponse {
    func toDomain() -> TravelPlace {
        TravelPlace(
            id: id,
            day: day,
            sequence: sequence,
            travelerTip: travelerTip ?? "",
            estimatedDuration: estimatedDuration,
            place: place.toDomain()
        )
    }
}

extension PlaceResponse {
    func toDomain() -> PlaceInfo {
        PlaceInfo(
            googlePlaceId: googlePlaceId,
            latitude: latitude,
            longitude: longitude,
            name: name,
            regularOpeningHours: regularOpeningHours,
            category: PlaceCategory(rawValue: category ?? "") ?? .etc
        )
    }
}
