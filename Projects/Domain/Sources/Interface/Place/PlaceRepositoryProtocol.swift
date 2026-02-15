//
//  PlaceRepositoryProtocol.swift
//  Domain
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public protocol PlaceRepositoryInterface {
    func searchPlaces() async throws -> Int //임시
    func fetchPlacePhotos(googlePlaceId: String) async throws -> [PlacePhoto]
    func fetchPlaceDetail(googlePlaceId: String) async throws -> PlaceDetail
}
