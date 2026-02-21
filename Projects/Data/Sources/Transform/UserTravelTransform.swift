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

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }
}
