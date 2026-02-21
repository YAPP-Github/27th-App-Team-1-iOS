//
//  WeatherInfo.swift
//  Domain
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct DailyWeatherInfo {
    public let date: Date
    public let maxTemperature: Double
    public let minTemperature: Double
    public let weatherType: String

    public init(
        date: Date,
        maxTemperature: Double,
        minTemperature: Double,
        weatherType: String
    ) {
        self.date = date
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
        self.weatherType = weatherType
    }
}
