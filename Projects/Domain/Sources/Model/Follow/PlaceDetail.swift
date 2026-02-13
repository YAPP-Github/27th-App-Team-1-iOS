//
//  PlaceDetail.swift
//  Domain
//
//  Created by kimnahun on 2026-02-09.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

/// 장소 상세 정보
public struct PlaceDetail: Hashable {
    public let id: String
    public let name: String
    public let thumbnail: String?
    public let nationalPhoneNumber: String?
    public let internationalPhoneNumber: String?
    public let formattedAddress: String?
    public let location: PlaceLocation
    public let userRatingCount: Int?
    public let rating: Double?
    public let regularOpeningHours: [String]?
    public let googleMapsUri: String?
    public let websiteUri: String?

    public init(
        id: String,
        name: String,
        thumbnail: String? = nil,
        nationalPhoneNumber: String? = nil,
        internationalPhoneNumber: String? = nil,
        formattedAddress: String? = nil,
        location: PlaceLocation,
        userRatingCount: Int? = nil,
        rating: Double? = nil,
        regularOpeningHours: [String]? = nil,
        googleMapsUri: String? = nil,
        websiteUri: String? = nil
    ) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.nationalPhoneNumber = nationalPhoneNumber
        self.internationalPhoneNumber = internationalPhoneNumber
        self.formattedAddress = formattedAddress
        self.location = location
        self.userRatingCount = userRatingCount
        self.rating = rating
        self.regularOpeningHours = regularOpeningHours
        self.googleMapsUri = googleMapsUri
        self.websiteUri = websiteUri
    }
}

/// 장소 위치 정보
public struct PlaceLocation: Hashable {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
