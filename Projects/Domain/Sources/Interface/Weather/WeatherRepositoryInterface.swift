//
//  WeatherRepositoryInterface.swift
//  Domain
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public protocol WeatherRepositoryInterface {
    func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherInfo
}
