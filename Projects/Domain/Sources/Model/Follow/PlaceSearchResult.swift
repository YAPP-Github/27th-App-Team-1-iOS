//
//  PlaceSearchResult.swift
//  Domain
//
//  Created by kimnahun on 2026-02-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct PlaceSearchResult {
    public let googlePlaceId: String
    public let name: String
    public let address: String
    public let latitude: Double
    public let longitude: Double

    public init(
        googlePlaceId: String,
        name: String,
        address: String,
        latitude: Double,
        longitude: Double
    ) {
        self.googlePlaceId = googlePlaceId
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}
