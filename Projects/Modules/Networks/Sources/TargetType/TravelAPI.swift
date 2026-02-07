//
//  TravelAPI.swift
//  Networks
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import Moya

public enum TravelAPI {
    /// 템플릿으로 내 여행 생성
    case createUserTravel(request: CreateUserTravelRequest)
}

extension TravelAPI: TargetType {
    public var baseURL: URL {
        NetworkConfiguration.baseURL
    }

    public var path: String {
        switch self {
        case .createUserTravel:
            return "/api/v1/travels"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .createUserTravel:
            return .post
        }
    }

    public var task: Moya.Task {
        switch self {
        case .createUserTravel(let request):
            return .requestJSONEncodable(request)
        }
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
