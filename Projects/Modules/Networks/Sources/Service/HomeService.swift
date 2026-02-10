//
//  HomeService.swift
//  Networks
//
//  Created by 최안용 on 2/4/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Moya

// MARK: - API 나오기 전 임시
public protocol HomeServiceProtocol {
    //임시
    func getMyTrip() async throws -> Int
    
    func getCategoryList() async throws -> [ProgramResponse]
    func getPopularTripList(id: Int?, page: Int?, size: Int?) async throws -> TripResponse
    func getRecommendTripList(page: Int?, size: Int?) async throws -> TripResponse
}

public final class HomeService: HomeServiceProtocol {
    private let provider: MoyaProvider<HomeAPI>
    
    public init(provider: MoyaProvider<HomeAPI> = MoyaProvider<HomeAPI>()) {
        self.provider = provider
    }
    
    public func getMyTrip() async throws -> Int {
        try await provider.asyncThowsRequest(.getMyTrip)
    }
    
    public func getCategoryList() async throws -> [ProgramResponse] {
        try await provider.asyncThowsRequest(.getCategoryList)
    }
    
    public func getPopularTripList(id: Int?, page: Int?, size: Int?) async throws -> TripResponse {
        try await provider.asyncThowsRequest(.getPopularTripList(id: id, page: page, size: size))
    }
    
    public func getRecommendTripList(page: Int?, size: Int?) async throws -> TripResponse {
        try await provider.asyncThowsRequest(.getRecommendTripList(page: page, size: size))
    }
}
