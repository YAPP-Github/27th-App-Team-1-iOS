//
//  WeatherService.swift
//  Networks
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import Moya

public protocol WeatherServiceProtocol {
    func getForecast(latitude: Double, longitude: Double, days: Int) async throws -> ForecastResponse
}

public final class WeatherService: WeatherServiceProtocol {
    private let provider: MoyaProvider<WeatherAPI>

    public init(provider: MoyaProvider<WeatherAPI> = MoyaProvider<WeatherAPI>()) {
        self.provider = provider
    }

    public func getForecast(latitude: Double, longitude: Double, days: Int) async throws -> ForecastResponse {
        try await provider.asyncThrowsRequestRaw(
            .getForecast(latitude: latitude, longitude: longitude, days: days)
        )
    }
}
