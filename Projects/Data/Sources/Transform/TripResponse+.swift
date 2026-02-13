//
//  TripResponse+.swift
//  Data
//
//  Created by 최안용 on 2/10/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension TripResponse {
    public func toDomain() -> [TripInfo] {
        self.content.map {
            .init(
                id: $0.travelId,
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
