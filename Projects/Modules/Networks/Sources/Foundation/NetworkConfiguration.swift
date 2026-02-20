//
//  NetworkConfiguration.swift
//  Networks
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public enum NetworkConfiguration {
    public static var baseURL: URL {
        // 테스트 환경에서는 Bundle.main이 Xcode 도구를 가리키므로 테스트 번들에서 찾음
        let bundle = Bundle.allBundles.first { $0.bundlePath.hasSuffix(".xctest") } ?? Bundle.main

        guard let urlString = bundle.infoDictionary?["BASE_URL"] as? String,
              let url = URL(string: urlString) else {
            fatalError("BASE_URL not found in Info.plist")
        }
        return url
    }
    
    public static var apiKey: String {
        let bundle = Bundle.main
        guard let apiHeader = bundle.infoDictionary?["X-API-KEY"] as? String else {
            fatalError("X-API-KEY not found in Info.plist")
        }
        return apiHeader
    }
}
