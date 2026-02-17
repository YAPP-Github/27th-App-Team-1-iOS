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
    
    public init(service: PlaceServiceProtocol) {
        self.service = service
    }
    
    public func searchPlaces() async throws -> Int {
        do {
            return try await service.searchPlaces()
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
