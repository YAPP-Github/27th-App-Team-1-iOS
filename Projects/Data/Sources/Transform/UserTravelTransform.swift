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
