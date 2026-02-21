//
//  WeatherResponse.swift
//  Networks
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

// MARK: - Forecast Response

public struct ForecastResponse: Decodable {
    public let forecastDays: [ForecastDayResponse]
}

public struct ForecastDayResponse: Decodable {
    public let displayDate: DateResponse
    public let daytimeForecast: ForecastPeriodResponse?
    public let maxTemperature: TemperatureResponse?
    public let minTemperature: TemperatureResponse?
}

public struct DateResponse: Decodable {
    public let year: Int
    public let month: Int
    public let day: Int
}

public struct ForecastPeriodResponse: Decodable {
    public let weatherCondition: WeatherConditionResponse
}

public struct WeatherConditionResponse: Decodable {
    public let type: String?
    public let iconBaseUri: String?
    public let icon: String?
    public let description: WeatherDescriptionResponse?
}

public struct WeatherDescriptionResponse: Decodable {
    public let text: String
}

public struct TemperatureResponse: Decodable {
    public let degrees: Double
    public let unit: String?
}
