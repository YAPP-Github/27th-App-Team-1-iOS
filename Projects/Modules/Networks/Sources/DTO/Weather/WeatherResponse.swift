//
//  WeatherResponse.swift
//  Networks
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct CurrentWeatherResponse: Decodable {
    public let temperature: TemperatureResponse
    public let weatherCondition: WeatherConditionResponse
    public let relativeHumidity: Int?
    public let iconBaseUri: String?
    public let icon: String?
}

public struct TemperatureResponse: Decodable {
    public let degrees: Double
    public let unit: String
}

public struct WeatherConditionResponse: Decodable {
    public let description: WeatherDescriptionResponse
}

public struct WeatherDescriptionResponse: Decodable {
    public let text: String
}
