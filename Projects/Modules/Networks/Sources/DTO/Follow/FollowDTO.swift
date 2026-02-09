//
//  FollowDTO.swift
//  Networks
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

// MARK: - Content Card Response (여행 템플릿 상세)

public struct FollowContentCardResponse: Decodable, Sendable {
    public let travelId: String
    public let country: String
    public let city: String
    public let budgetPerPerson: Int
    public let nights: Int
    public let days: Int
    public let youtube: YouTubeResponse
}

public struct YouTubeResponse: Decodable, Sendable {
    public let title: String
    public let name: String
    public let thumbnail: String?
    public let profileImage: String?
    public let link: String?
    public let summary: String
}

// MARK: - Itinerary Response (여행 일정)

public struct FollowItineraryResponse: Decodable, Sendable {
    public let itineraries: [FollowPlaceResponse]
}

public struct FollowPlaceResponse: Decodable, Sendable {
    public let id: Int
    public let day: Int
    public let sequence: Int
    public let distanceKm: Double?
    public let transportation: [TransportationResponse]?
    public let youtubeTips: [String]?
    public let planB: [PlaceResponse]?
    public let estimatedDuration: Int?
    public let place: PlaceResponse
}

public struct TransportationResponse: Decodable, Sendable {
    public let mode: String
    public let timeMin: Int?
}

public struct PlaceResponse: Decodable, Sendable {
    public let googlePlaceId: String
    public let thumbnail: String?
    public let latitude: Double
    public let longitude: Double
    public let name: String
    public let regularOpeningHours: String?
    public let googleMapsUri: String
}
