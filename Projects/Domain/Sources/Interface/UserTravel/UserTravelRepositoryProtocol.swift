//
//  UserTravelRepositoryProtocol.swift
//  Domain
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public protocol UserTravelRepositoryProtocol {
    func createUserTravel(request: CreateTravelRequest) async throws -> CreateTravelResponse
    func fetchUpcoming() async throws -> MyTripSummary
}
