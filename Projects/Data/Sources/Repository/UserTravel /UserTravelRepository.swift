//
//  UserTravelRepository.swift
//  Data
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

public final class UserTravelRepository: UserTravelRepositoryInterface {
    private let service: UserTravelServiceProtocol
    private let dateFormatter: DateFormatter
    
    public init(service: UserTravelServiceProtocol) {
        self.service = service
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    public func createUserTravel(request: CreateTravelRequest) async throws -> CreateTravelResponse {
        do {
            let dto = CreateUserTravelRequest(
                templateId: request.templateId,
                startDate: dateFormatter.string(from: request.startDate),
                endDate: dateFormatter.string(from: request.endDate)
            )
            return try await service.createUserTravel(request: dto).toDomain()
        } catch {
            throw error.toNDGLError()
        }
    }
    
    public func fetchUpcoming() async throws -> MyTripSummary {
        do {
            return try await service.getUpcoming().toDomain()
        } catch {
            throw error.toNDGLError()
        }
    }
    
    public func fetchUpcomingList(page: Int?, size: Int?) async throws -> [UpcomingInfo] {
        do {
            return try await service.getUpcomingList(page: page, size: size).toDomain()
        } catch {
            throw error.toNDGLError()
        }
    }

    public func fetchUserTravelDetail(id: Int) async throws -> TravelDetail {
        do {
            return try await service.getContentCard(id: id).toDomain()
        } catch {
            throw error.toNDGLError()
        }
    }

    public func fetchItinerary(travelId: Int, day: Int) async throws -> [TravelPlace] {
        do {
            return try await service.getItinerary(travelId: travelId, day: day).toDomain()
        } catch {
            throw error.toNDGLError()
        }
    }

    public func replaceItinerary(travelId: Int, places: [TravelPlace]) async throws {
        do {
            let items = places.enumerated().map { index, place in
                ReplaceItineraryItemRequest(
                    placeId: place.id,
                    day: place.day,
                    sequence: index + 1,
                    startTime: nil,
                    estimatedDuration: place.estimatedDuration,
                    travelerTip: nil
                )
            }
            try await service.replaceItinerary(
                travelId: travelId,
                request: ReplaceItineraryRequest(itineraries: items)
            )
        } catch {
            throw error.toNDGLError()
        }
    }
}
