//
//  UpcomingInfo.swift
//  Domain
//
//  Created by 최안용 on 2/22/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct UpcomingInfo {
    public let id: Int
    public let title: String
    public let country: String
    public let city: String
    public let startDate: Date
    public let endDate: Date
    public let nights: Int
    public let days: Int
    public let templateId: Int
    public let thumbnail: String?
    public let profileImage: String?
    
    public init(
        id: Int,
        title: String,
        country: String,
        city: String,
        startDate: Date,
        endDate: Date,
        nights: Int,
        days: Int,
        templateId: Int,
        thumbnail: String?,
        profileImage: String?
    ) {
        self.id = id
        self.title = title
        self.country = country
        self.city = city
        self.startDate = startDate
        self.endDate = endDate
        self.nights = nights
        self.days = days
        self.templateId = templateId
        self.thumbnail = thumbnail
        self.profileImage = profileImage
    }
}
