//
//  PlaceDTO.swift
//  Networks
//
//  Created by kimnahun on 2026-02-09.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

// MARK: - Place Detail Response

public struct PlaceDetailResponse: Decodable, Sendable {
    public let id: String
    public let name: String
    public let thumbnail: String?
    public let nationalPhoneNumber: String?
    public let internationalPhoneNumber: String?
    public let formattedAddress: String?
    public let location: PlaceLocationResponse
    public let userRatingCount: Int?
    public let rating: Double?
    public let regularOpeningHours: [String]?
    public let googleMapsUri: String?
    public let websiteUri: String?
}

public struct PlaceLocationResponse: Decodable, Sendable {
    public let latitude: Double
    public let longitude: Double
}

// MARK: - Place Photos Response

public struct PlacePhotosResponse: Decodable, Sendable {
    public let photos: [PlacePhotoResponse]
}

public struct PlacePhotoResponse: Decodable, Sendable {
    public let photoUri: String
    public let widthPx: Int
    public let heightPx: Int
}
