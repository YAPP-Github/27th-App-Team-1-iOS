//
//  WeatherRepository.swift
//  Data
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import Domain
import Networks

public final class WeatherRepository: WeatherRepositoryInterface {
    private let service: WeatherServiceProtocol

    public init(service: WeatherServiceProtocol) {
        self.service = service
    }

    public func fetchForecast(
        latitude: Double,
        longitude: Double,
        days: Int
    ) async throws -> [DailyWeatherInfo] {
        do {
            let response = try await service.getForecast(
                latitude: latitude,
                longitude: longitude,
                days: days
            )
            return response.forecastDays.compactMap { $0.toDomain() }
        } catch {
            throw error.toNDGLError()
        }
    }
}
