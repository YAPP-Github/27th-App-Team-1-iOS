//
//  UserTravelRepositoryInterface.swift
//  Domain
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public protocol UserTravelRepositoryInterface {
    func createUserTravel(request: CreateTravelRequest) async throws -> CreateTravelResponse
//    func fetchContentCard(id: Int) async throws ->
    func fetchUpcoming() async throws -> MyTripSummary
    func fetchUpcomingList(page: Int?, size: Int?) async throws -> [UpcomingInfo]
}
