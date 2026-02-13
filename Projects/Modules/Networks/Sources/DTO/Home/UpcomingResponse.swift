//
//  UpcomingResponse.swift
//  Networks
//
//  Created by 최안용 on 2/13/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct UpcomingResponse: Decodable {
    public let userTravelId: Int
    public let title: String
    public let country: String
    public let city: String
    public let startDate: String
    public let endDate: String
    public let nights: Int
    public let days: Int
    public let upcomingUserTravelPlace: UpcomingPlaceResponse
}

public struct UpcomingPlaceResponse: Decodable {
    public let id: Int
    public let estimatedDuration: Int
    public let place: UpcomingPlaceDetailResponse
}

public struct UpcomingPlaceDetailResponse: Decodable {
    public let googlePlaceId: String
    public let thumbnail: String?
    public let latitude: Double
    public let longitude: Double
    public let name: String
    public let regularOpeningHours: String?
    public let googleMapsUri: String
    public let category: String
}
