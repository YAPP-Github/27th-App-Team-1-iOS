//
//  TravelService.swift
//  Networks
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation
import Moya

public final class TravelService: TravelServiceProtocol, @unchecked Sendable {

    private let provider: MoyaProvider<TravelAPI>
    private let dateFormatter: DateFormatter

    public init(provider: MoyaProvider<TravelAPI> = MoyaProvider<TravelAPI>()) {
        self.provider = provider
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    public func createUserTravel(request: CreateTravelRequest) async -> Result<CreateTravelResponse, CreateTravelError> {
        // Domain → DTO 변환
        let dto = CreateUserTravelRequest(
            templateId: request.templateId,
            startDate: dateFormatter.string(from: request.startDate),
            endDate: dateFormatter.string(from: request.endDate)
        )

        let result: NetworkResult<CreateUserTravelResponse, CreateTravelError> = await provider.request(
            .createUserTravel(request: dto),
            errorMapper: CreateTravelError.init
        )

        // NetworkResult → Result 변환 + DTO → Domain 변환
        switch result {
        case .success(let response):
            return .success(CreateTravelResponse(userTravelId: response.userTravelId))
        case .failure(let error):
            return .failure(error)
        case .networkFailure(let error):
            return .failure(.unknown(code: "NETWORK", message: error.message))
        }
    }
}
