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

public final class UserTravelRepository: UserTravelRepositoryProtocol {
    private let service: UserTravelServiceProtocol
    
    public init(service: UserTravelServiceProtocol) {
        self.service = service
    }
    
    public func createUserTravel(request: CreateTravelRequest) async throws -> CreateTravelResponse {
        do {
            return try await service.createUserTravel(request: request)
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
}
