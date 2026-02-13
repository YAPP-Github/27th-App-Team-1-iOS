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
            id: place.id,
            name: place.name,
            thumbnail: place.thumbnail,
            nationalPhoneNumber: place.nationalPhoneNumber,
            internationalPhoneNumber: place.internationalPhoneNumber,
            formattedAddress: place.formattedAddress,
            location: place.location.toDomain(),
            userRatingCount: place.userRatingCount,
            rating: place.rating,
            regularOpeningHours: place.regularOpeningHours,
            googleMapsUri: place.googleMapsUri,
            websiteUri: place.websiteUri
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
