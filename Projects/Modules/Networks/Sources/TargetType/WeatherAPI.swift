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
    case getCurrentWeather(latitude: Double, longitude: Double)
}

extension WeatherAPI: TargetType {
    public var baseURL: URL {
        URL(string: "https://weather.googleapis.com")!
    }

    public var path: String {
        switch self {
        case .getCurrentWeather:
            return "/v1/currentConditions:lookup"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getCurrentWeather:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case .getCurrentWeather(let latitude, let longitude):
            return .requestParameters(
                parameters: [
                    "key": NetworkConfiguration.weatherApiKey,
                    "location.latitude": latitude,
                    "location.longitude": longitude
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
