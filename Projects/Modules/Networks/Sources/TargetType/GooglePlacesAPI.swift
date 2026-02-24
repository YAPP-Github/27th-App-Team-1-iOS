//
//  GooglePlacesAPI.swift
//  Networks
//
//  Created by kimnahun on 2026-02-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import Moya

public enum GooglePlacesAPI {
    case searchText(keyword: String)
}

extension GooglePlacesAPI: TargetType {
    public var baseURL: URL {
        URL(string: "https://places.googleapis.com")!
    }

    public var path: String {
        "/v1/places:searchText"
    }

    public var method: Moya.Method {
        .post
    }

    public var task: Moya.Task {
        switch self {
        case .searchText(let keyword):
            let body: [String: Any] = ["textQuery": keyword]
            let data = (try? JSONSerialization.data(withJSONObject: body)) ?? Data()
            return .requestData(data)
        }
    }

    public var headers: [String: String]? {
        [
            "Content-Type": "application/json",
            "X-Goog-Api-Key": NetworkConfiguration.weatherApiKey,
            "X-Goog-FieldMask": "places.id,places.displayName,places.formattedAddress,places.location"
        ]
    }
}
