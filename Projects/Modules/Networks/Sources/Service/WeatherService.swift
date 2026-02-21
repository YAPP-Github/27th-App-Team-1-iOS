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
    func getCurrentWeather(latitude: Double, longitude: Double) async throws -> CurrentWeatherResponse
}

public final class WeatherService: WeatherServiceProtocol {
    private let provider: MoyaProvider<WeatherAPI>

    public init(provider: MoyaProvider<WeatherAPI> = MoyaProvider<WeatherAPI>()) {
        self.provider = provider
    }

    public func getCurrentWeather(latitude: Double, longitude: Double) async throws -> CurrentWeatherResponse {
        try await provider.asyncThrowsRequestRaw(.getCurrentWeather(latitude: latitude, longitude: longitude))
    }
}
