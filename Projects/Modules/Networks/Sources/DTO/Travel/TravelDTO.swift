//
//  TravelDTO.swift
//  Networks
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

// MARK: - Request

public struct CreateUserTravelRequest: Encodable, Sendable {
    public let templateId: Int
    public let startDate: String
    public let endDate: String

    public init(templateId: Int, startDate: String, endDate: String) {
        self.templateId = templateId
        self.startDate = startDate
        self.endDate = endDate
    }
}

// MARK: - Response

public struct CreateUserTravelResponse: Decodable, Sendable {
    public let userTravelId: Int
}

// MARK: - Add Itinerary Request

public struct AddItineraryRequest: Encodable, Sendable {
    public let googlePlaceId: String
    public let day: Int
    public let sequence: Int

    public init(googlePlaceId: String, day: Int, sequence: Int) {
        self.googlePlaceId = googlePlaceId
        self.day = day
        self.sequence = sequence
    }
}

// MARK: - Replace Itinerary Request

public struct ReplaceItineraryRequest: Encodable, Sendable {
    public let itineraries: [ReplaceItineraryItemRequest]

    public init(itineraries: [ReplaceItineraryItemRequest]) {
        self.itineraries = itineraries
    }
}

public struct ReplaceItineraryItemRequest: Encodable, Sendable {
    public let googlePlaceId: String
    public let day: Int
    public let sequence: Int
    public let startTime: String?
    public let estimatedDuration: Int?
    public let travelerTip: String?

    public init(
        googlePlaceId: String,
        day: Int,
        sequence: Int,
        startTime: String? = nil,
        estimatedDuration: Int? = nil,
        travelerTip: String? = nil
    ) {
        self.googlePlaceId = googlePlaceId
        self.day = day
        self.sequence = sequence
        self.startTime = startTime
        self.estimatedDuration = estimatedDuration
        self.travelerTip = travelerTip
    }
}

// MARK: - User Travel Itinerary Response

public struct UserTravelItineraryResponse: Decodable, Sendable {
    public let itineraries: [UserTravelPlaceResponse]
}

public struct UserTravelPlaceResponse: Decodable, Sendable {
    public let id: Int
    public let day: Int
    public let sequence: Int
    public let distanceKm: Double?
    public let transportation: [TransportationResponse]?
    public let travelerTips: [String]?
    public let planB: [PlanBResponse]?
    public let estimatedDuration: Int?
    public let place: PlaceResponse?
}
