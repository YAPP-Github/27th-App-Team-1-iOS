//
//  HomeRepository.swift
//  Data
//
//  Created by 최안용 on 2/4/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

public final class HomeRepository: HomeRepositoryInterface {
    private let homeService: HomeServiceProtocol
    
    public init(homeService: HomeServiceProtocol) {
        self.homeService = homeService
    }
    
    public func fetchMyTripInfo() async throws -> MyTripSummary {
        do {
            return try await homeService.getUpcoming().toDomain()
        } catch {
            throw error.toNDGLError()
        }
    }
    
    public func fetchCategoryList() async throws -> [TripCategory] {
        do {
            return try await homeService.getCategoryList().map { $0.toDomain() }
        } catch {
            throw error.toNDGLError()
        }
    }
    
    public func fetchPopularTripList(id: Int?, page: Int?, size: Int?) async throws -> [TripInfo] {
        do {
            return try await homeService.getPopularTripList(id: id, page: page, size: size).toDomain()
        } catch {
            throw error.toNDGLError()
        }
    }
    
    public func fetchRecommendTripList(page: Int?, size: Int?) async throws -> [TripInfo] {
        do {
            return try await homeService.getRecommendTripList(page: page, size: size).toDomain()
        } catch {
            throw error.toNDGLError()
        }
    }
}
