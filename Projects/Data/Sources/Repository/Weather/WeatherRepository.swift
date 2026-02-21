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

    public func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherInfo {
        do {
            let response = try await service.getCurrentWeather(latitude: latitude, longitude: longitude)
            return response.toDomain()
        } catch {
            throw error.toNDGLError()
        }
    }
}
