//
//  TripInfo.swift
//  Domain
//
//  Created by 최안용 on 2/4/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct TripInfo {
    public let id: Int
    public let title: String
    public let thumbnailUrl: String
    public let creator: String
    public let country: String
    public let city: String
    public let nights: Int
    public let days: Int
    
    public init(
        id: Int,
        title: String,
        thumbnailUrl: String,
        creator: String,
        country: String,
        city: String,
        nights: Int,
        days: Int
    ) {
        self.id = id
        self.title = title
        self.thumbnailUrl = thumbnailUrl
        self.creator = creator
        self.country = country
        self.city = city
        self.nights = nights
        self.days = days
    }
}
