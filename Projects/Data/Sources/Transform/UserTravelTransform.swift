//
//  UserTravelTransform.swift
//  Data
//
//  Created by 최안용 on 2/15/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks


extension UserContentCardResponse {
    func toDomain() -> TravelDetail {
        TravelDetail(
            travelId: userTravelId,
            country: country,
            city: city,
            budgetPerPerson: 0,
            nights: nights,
            days: days,
            youtube: YouTubeInfo(
                title: title,
                youtuber: "",
                thumbnail: nil,
                profileImage: nil,
                link: nil,
                summary: ""
            )
        )
    }
}

extension UpcomingResponse {
    func toDomain() -> MyTripSummary {
        let schedule: Schedule?
        if let place = self.upcomingUserTravelPlace {
            schedule = .init(
                id: place.id,
                day: 1,
                placeName: place.place.name,
                thumbnailUrl: place.place.thumbnail ?? "",
                transport: place.place.category,
                estimatedDuration: place.estimatedDuration,
                latitude: place.place.latitude,
                longitude: place.place.longitude
            )
        } else {
            schedule = nil
        }

        return .init(
            id: self.userTravelId,
            title: self.title,
            city: self.city,
            country: self.country,
            startDay: self.startDate.toDate() ?? .now,
            endDay: self.endDate.toDate() ?? .now,
            thumbnail: self.thumbnail,
            tripSchedule: schedule
        )
    }
}

extension CreateUserTravelResponse {
    func toDomain() -> CreateTravelResponse {
        .init(userTravelId: self.userTravelId)
    }
}

extension UserTravelItineraryResponse {
    func toDomain() -> [TravelPlace] {
        itineraries.compactMap { $0.toDomain() }
    }
}

extension UserTravelPlaceResponse {
    func toDomain() -> TravelPlace? {
        guard let place else { return nil }
        return TravelPlace(
            id: id,
            day: day,
            sequence: sequence,
            distanceKm: distanceKm,
            transportation: transportation?.map { $0.toDomain() } ?? [],
            youtubeTips: memo.map { [$0] } ?? travelerTips ?? [],
            planB: planB?.map { $0.toDomain() } ?? [],
            estimatedDuration: estimatedDuration,
            place: place.toDomain()
        )
    }
}

extension UpcomingListResponse {
    func toDomain() -> [UpcomingInfo] {
        self.content.map {
            .init(
                id: $0.id,
                title: $0.title,
                country: $0.country,
                city: $0.city,
                startDate: $0.startDate.toDate() ?? .now,
                endDate: $0.endDate.toDate() ?? .now,
                nights: $0.nights,
                days: $0.days,
                templateId: $0.templateId,
                thumbnail: $0.thumbnail,
                profileImage: $0.profileImage
            )
        }
    }
}
