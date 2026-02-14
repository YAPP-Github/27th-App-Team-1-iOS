//
//  TravelProgramRepository.swift
//  Data
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

public final class TravelProgramRepository: TravelProgramRepositoryProtocol {
    private let service: TravelProgramServiceProtocol
    
    public init(service: TravelProgramServiceProtocol) {
        self.service = service
    }
    
    public func fetchCategoryList() async throws -> [TripCategory] {
        do {
            return try await service.getTravelPrograms().map { $0.toDomain() }
        } catch {
            throw error.toNDGLError()
        }
    }
}
