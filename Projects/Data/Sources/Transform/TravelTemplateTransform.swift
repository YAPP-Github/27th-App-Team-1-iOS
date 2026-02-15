//
//  TravelTemplateTransform.swift
//  Data
//
//  Created by 최안용 on 2/15/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

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

extension TripResponse {
    func toDomain() -> [TripInfo] {
        self.content.map {
            .init(
                id: $0.id,
                title: $0.title,
                thumbnailUrl: $0.thumbnail ?? "",
                creator: $0.programName,
                country: $0.country,
                city: $0.city,
                nights: $0.nights,
                days: $0.days
            )
        }
    }
}
