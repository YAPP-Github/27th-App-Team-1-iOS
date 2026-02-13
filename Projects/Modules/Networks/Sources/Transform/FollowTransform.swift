//
//  FollowTransform.swift
//  Networks
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation

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
        itineraries.map { $0.toDomain() }
    }
}

extension FollowPlaceResponse {
    func toDomain() -> TravelPlace {
        TravelPlace(
            id: id,
            day: day,
            sequence: sequence,
            distanceKm: distanceKm,
            transportation: transportation?.map { $0.toDomain() } ?? [],
            youtubeTips: youtubeTips ?? [],
            planB: planB?.map { $0.toDomain() } ?? [],
            estimatedDuration: estimatedDuration,
            place: place.toDomain()
        )
    }
}

extension TransportationResponse {
    func toDomain() -> Transportation {
        Transportation(
            mode: mode,
            timeMin: timeMin
        )
    }
}

extension PlanBResponse {
    func toDomain() -> PlanBInfo {
        PlanBInfo(
            name: name,
            feature: feature
        )
    }
}

extension PlaceResponse {
    func toDomain() -> PlaceInfo {
        PlaceInfo(
            googlePlaceId: googlePlaceId,
            thumbnail: thumbnail,
            latitude: latitude,
            longitude: longitude,
            name: name,
            regularOpeningHours: regularOpeningHours,
            googleMapsUri: googleMapsUri
        )
    }
}
