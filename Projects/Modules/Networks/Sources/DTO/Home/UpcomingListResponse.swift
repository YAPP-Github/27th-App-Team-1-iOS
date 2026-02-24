//
//  UpcomingListResponse.swift
//  Networks
//
//  Created by 최안용 on 2/22/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct UpcomingListResponse: Decodable {
    public let content: [UpcomingContentResponse]
    public let hasNext: Bool
}

public struct UpcomingContentResponse: Decodable {
    public let id: Int
    public let title: String
    public let country: String
    public let countryName: String?
    public let city: String
    public let startDate: String
    public let endDate: String
    public let nights: Int
    public let days: Int
    public let templateId: Int
    public let thumbnail: String?
    public let profileImage: String?
}
