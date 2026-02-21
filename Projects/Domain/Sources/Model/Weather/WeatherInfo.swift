//
//  WeatherInfo.swift
//  Domain
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct WeatherInfo {
    public let temperature: Double
    public let description: String
    public let iconUrl: String
    public let humidity: Int

    public init(
        temperature: Double,
        description: String,
        iconUrl: String,
        humidity: Int
    ) {
        self.temperature = temperature
        self.description = description
        self.iconUrl = iconUrl
        self.humidity = humidity
    }
}
