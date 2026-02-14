//
//  PlaceService.swift
//  Networks
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Moya

public protocol PlaceServiceProtocol {
    func searchPlaces() async throws -> Int
    func getPlacePhotos(googlePlaceId: String) async throws -> PlacePhotosResponse
    func getPlaceDetails(googlePlaceId: String) async throws -> PlaceDetailResponse
}

public final class PlaceService: PlaceServiceProtocol {
    private let provider: MoyaProvider<PlaceAPI>
    
    public init(provider: MoyaProvider<PlaceAPI> = MoyaProvider<PlaceAPI>()) {
        self.provider = provider
    }
    
    public func searchPlaces() async throws -> Int {
        try await provider.asyncThowsRequest(.searchPlaces)
    }
    
    public func getPlacePhotos(googlePlaceId: String) async throws -> PlacePhotosResponse {
        try await provider.asyncThowsRequest(.getPlacePhotos(googlePlaceId: googlePlaceId))
    }
    
    public func getPlaceDetails(googlePlaceId: String) async throws -> PlaceDetailResponse {
        try await provider.asyncThowsRequest(.getPlacePhotos(googlePlaceId: googlePlaceId))
    }
}
