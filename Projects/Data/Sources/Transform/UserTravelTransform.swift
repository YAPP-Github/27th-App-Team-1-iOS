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
        return .init(
            id: self.userTravelId,
            title: self.title,
            startDay: self.startDate.toDate() ?? .now,
            endDay: self.endDate.toDate() ?? .now,
            tripSchedule: .init(
                id: self.upcomingUserTravelPlace.id,
                day: 1, // 서버에서 첫 일정만 보내주고 있음
                placeName: self.upcomingUserTravelPlace.place.name,
                thumbnailUrl: self.upcomingUserTravelPlace.place.thumbnail ?? "",
                transport: self.upcomingUserTravelPlace.place.category,
                estimatedDuration: self.upcomingUserTravelPlace.estimatedDuration
            )
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
