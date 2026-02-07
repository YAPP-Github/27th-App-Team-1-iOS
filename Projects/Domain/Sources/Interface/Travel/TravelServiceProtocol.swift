//
//  TravelServiceProtocol.swift
//  Domain
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public protocol TravelServiceProtocol: Sendable {
    func createUserTravel(request: CreateTravelRequest) async -> Result<CreateTravelResponse, CreateTravelError>
}
