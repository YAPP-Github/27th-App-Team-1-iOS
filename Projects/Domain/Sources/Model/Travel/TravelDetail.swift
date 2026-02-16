//
//  TravelDetail.swift
//  Domain
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

/// 여행 상세 정보
public struct TravelDetail: Hashable {
    public let travelId: Int
    public let country: String
    public let city: String
    public let budgetPerPerson: Int
    public let nights: Int
    public let days: Int
    public let youtube: YouTubeInfo

    public init(
        travelId: Int,
        country: String,
        city: String,
        budgetPerPerson: Int,
        nights: Int,
        days: Int,
        youtube: YouTubeInfo
    ) {
        self.travelId = travelId
        self.country = country
        self.city = city
        self.budgetPerPerson = budgetPerPerson
        self.nights = nights
        self.days = days
        self.youtube = youtube
    }
}

/// 유튜브 정보
public struct YouTubeInfo: Hashable {
    public let title: String
    public let youtuber: String
    public let thumbnail: String?
    public let profileImage: String?
    public let link: String?
    public let summary: String

    public init(
        title: String,
        youtuber: String,
        thumbnail: String?,
        profileImage: String?,
        link: String?,
        summary: String
    ) {
        self.title = title
        self.youtuber = youtuber
        self.thumbnail = thumbnail
        self.profileImage = profileImage
        self.link = link
        self.summary = summary
    }
}
