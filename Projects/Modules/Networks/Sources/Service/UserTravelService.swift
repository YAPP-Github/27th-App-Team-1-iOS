//
//  UserTravelService.swift
//  Networks
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Moya

public protocol UserTravelServiceProtocol {
    func createUserTravel(request: CreateUserTravelRequest) async throws -> CreateUserTravelResponse
    func getUpcoming() async throws -> UpcomingResponse
}

public final class UserTravelService: UserTravelServiceProtocol {
    private let provider: MoyaProvider<UserTravelAPI>
    
    public init(provider: MoyaProvider<UserTravelAPI> = MoyaProvider<UserTravelAPI>()) {
        self.provider = provider
    }
    
    public func createUserTravel(request: CreateUserTravelRequest) async throws -> CreateUserTravelResponse {
        try await provider.asyncThowsRequest(.createUserTravel(request: request))
    }
    
    public func getUpcoming() async throws -> UpcomingResponse {
        try await provider.asyncThowsRequest(.getUpcoming)
    }
}
