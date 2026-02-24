//
//  GooglePlacesResponse.swift
//  Networks
//
//  Created by kimnahun on 2026-02-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct GooglePlacesSearchResponse: Decodable {
    public let places: [GooglePlaceItem]?
}

public struct GooglePlaceItem: Decodable {
    public let id: String
    public let displayName: GooglePlaceLocalizedText?
    public let formattedAddress: String?
    public let location: GooglePlaceLocation?
}

public struct GooglePlaceLocalizedText: Decodable {
    public let text: String?
}

public struct GooglePlaceLocation: Decodable {
    public let latitude: Double
    public let longitude: Double
}
