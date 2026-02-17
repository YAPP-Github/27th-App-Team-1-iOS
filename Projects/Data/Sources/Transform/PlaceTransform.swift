//
//  PlaceTransform.swift
//  Data
//
//  Created by 최안용 on 2/15/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

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
