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

extension ForecastDayResponse {
    func toDomain() -> DailyWeatherInfo? {
        var components = DateComponents()
        components.year = displayDate.year
        components.month = displayDate.month
        components.day = displayDate.day

        guard let date = Calendar.current.date(from: components) else { return nil }

        return DailyWeatherInfo(
            date: date,
            maxTemperature: maxTemperature?.degrees ?? 0,
            minTemperature: minTemperature?.degrees ?? 0,
            weatherType: daytimeForecast?.weatherCondition.type ?? "CLOUDY"
        )
    }
}
