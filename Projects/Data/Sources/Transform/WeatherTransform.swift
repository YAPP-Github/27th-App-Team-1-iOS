//
//  WeatherTransform.swift
//  Data
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import Domain
import Networks

extension CurrentWeatherResponse {
    func toDomain() -> WeatherInfo {
        let iconUrl: String
        if let baseUri = iconBaseUri, let icon = icon {
            iconUrl = "\(baseUri)/\(icon).png"
        } else {
            iconUrl = ""
        }

        return WeatherInfo(
            temperature: temperature.degrees,
            description: weatherCondition.description.text,
            iconUrl: iconUrl,
            humidity: relativeHumidity ?? 0
        )
    }
}
