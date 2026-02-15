//
//  TravelTemplateRepositoryProtocol.swift
//  Domain
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public protocol TravelTemplateRepositoryInterface {
    func fetchPlaces(travelId: Int, day: Int) async throws -> [TravelPlace]
    func fetchTravelDetail(id: Int) async throws -> TravelDetail
    func searchTemplate() async throws -> Int
    func fetchPopularTripList(id: Int?, page: Int?, size: Int?) async throws -> [TripInfo]
    func fetchRecommendTripList(page: Int?, size: Int?) async throws -> [TripInfo]
}
