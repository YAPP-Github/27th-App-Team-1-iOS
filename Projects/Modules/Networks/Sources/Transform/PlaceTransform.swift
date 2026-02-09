//
//  PlaceTransform.swift
//  Networks
//
//  Created by kimnahun on 2026-02-09.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation

// MARK: - PlaceDetailResponse to PlaceDetail

extension PlaceDetailResponse {
    func toDomain() -> PlaceDetail {
        PlaceDetail(
            id: id,
            name: name,
            thumbnail: thumbnail,
            nationalPhoneNumber: nationalPhoneNumber,
            internationalPhoneNumber: internationalPhoneNumber,
            formattedAddress: formattedAddress,
            location: location.toDomain(),
            userRatingCount: userRatingCount,
            rating: rating,
            regularOpeningHours: regularOpeningHours,
            googleMapsUri: googleMapsUri,
            websiteUri: websiteUri
        )
    }
}

extension PlaceLocationResponse {
    func toDomain() -> PlaceLocation {
        PlaceLocation(
            latitude: latitude,
            longitude: longitude
        )
    }
}

// MARK: - PlacePhotosResponse to [PlacePhoto]

extension PlacePhotosResponse {
    func toDomain() -> [PlacePhoto] {
        photos.map { $0.toDomain() }
    }
}

extension PlacePhotoResponse {
    func toDomain() -> PlacePhoto {
        PlacePhoto(
            photoUri: photoUri,
            widthPx: widthPx,
            heightPx: heightPx
        )
    }
}
