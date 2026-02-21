//
//  WeatherAPI.swift
//  Networks
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import Moya

public enum WeatherAPI {
    case getForecast(latitude: Double, longitude: Double, days: Int)
}

extension WeatherAPI: TargetType {
    public var baseURL: URL {
        URL(string: "https://weather.googleapis.com")!
    }

    public var path: String {
        switch self {
        case .getForecast:
            return "/v1/forecast/days:lookup"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getForecast:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case .getForecast(let latitude, let longitude, let days):
            return .requestParameters(
                parameters: [
                    "key": NetworkConfiguration.weatherApiKey,
                    "location.latitude": latitude,
                    "location.longitude": longitude,
                    "days": days
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
