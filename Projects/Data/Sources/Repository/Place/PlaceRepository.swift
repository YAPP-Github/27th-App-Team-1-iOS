//
//  PlaceRepository.swift
//  Data
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

public final class PlaceRepository: PlaceRepositoryInterface {
    private let service: PlaceServiceProtocol
    private let googlePlacesService: GooglePlacesServiceProtocol

    public init(service: PlaceServiceProtocol, googlePlacesService: GooglePlacesServiceProtocol) {
        self.service = service
        self.googlePlacesService = googlePlacesService
    }

    public func searchPlaces(keyword: String) async throws -> [PlaceSearchResult] {
        do {
            let response = try await googlePlacesService.searchText(keyword: keyword)
            return (response.places ?? []).compactMap { $0.toDomain() }
        } catch {
            throw error.toNDGLError()
        }
    }

    public func registerPlace(googlePlaceId: String) async throws {
        do {
            try await service.registerPlace(googlePlaceId: googlePlaceId)
        } catch {
            throw error.toNDGLError()
        }
    }
    
    public func fetchPlacePhotos(googlePlaceId: String) async throws -> [PlacePhoto] {
        do {
            return try await service.getPlacePhotos(googlePlaceId: googlePlaceId).toDomain()
        } catch {
            throw error.toNDGLError()
        }
    }
    
    public func fetchPlaceDetail(googlePlaceId: String) async throws -> PlaceDetail {
        do {
            return try await service.getPlaceDetails(googlePlaceId: googlePlaceId).toDomain()
        } catch {
            throw error.toNDGLError()
        }
    }
}
