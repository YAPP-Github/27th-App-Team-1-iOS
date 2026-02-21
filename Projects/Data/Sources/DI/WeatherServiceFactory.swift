//
//  WeatherServiceFactory.swift
//  Data
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import Networks
import Moya

public func makeWeatherService() -> WeatherServiceProtocol {
    let provider = MoyaProvider<WeatherAPI>()
    return WeatherService(provider: provider)
}
