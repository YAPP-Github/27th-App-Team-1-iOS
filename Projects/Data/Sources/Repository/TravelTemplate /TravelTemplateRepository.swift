//
//  TravelTemplateRepository.swift
//  Data
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

public final class TravelTemplateRepository: TravelTemplateRepositoryProtocol {
    private let service: TravelTemplateServiceProtocol
    
    public init(service: TravelTemplateServiceProtocol) {
        self.service = service
    }
    
    public func fetchPlaces(travelId: Int, day: Int) async throws -> [TravelPlace] {
        do {
            return try await service.getItinerary(travelId: travelId, day: day)
        } catch {
            throw error.toNDGLError()
        }
    }
    
    public func fetchTravelDetail(id: Int) async throws -> TravelDetail {
        do {
            return try await service.getContentCard(id: id)
        } catch {
            throw error.toNDGLError()
        }
    }
    
    public func searchTemplate() async throws -> Int {
        do {
            return try await service.searchTemplate()
        } catch {
            throw error.toNDGLError()
        }
    }
    
    public func fetchPopularTripList(id: Int?, page: Int?, size: Int?) async throws -> [TripInfo] {
        do {
            return try await service.getPopularTripList(id: id, page: page, size: size).toDomain()
        } catch {
            throw error.toNDGLError()
        }
    }
    
    public func fetchRecommendTripList(page: Int?, size: Int?) async throws -> [TripInfo] {
        do {
            return try await service.getRecommendTripList(page: page, size: size).toDomain()
        } catch {
            throw error.toNDGLError()
        }
    }
}
