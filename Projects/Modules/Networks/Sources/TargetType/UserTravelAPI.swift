//
//  UserTravelAPI.swift
//  Networks
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Moya

public enum UserTravelAPI {
    case createUserTravel(request: CreateUserTravelRequest)
    case getUpcoming
}

extension UserTravelAPI: TargetType {
    public var baseURL: URL {
        NetworkConfiguration.baseURL
    }
    
    public var path: String {
        switch self {
        case .createUserTravel:
            return "/api/v1/travels"
        case .getUpcoming:
            return "/api/v1/travels/upcoming"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .createUserTravel:
            return .post
        case .getUpcoming:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .createUserTravel(let request):
            return .requestJSONEncodable(request)
        case .getUpcoming:
            return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        #if !DEBUG
        headers["X-API-KEY"] = NetworkConfiguration.apiKey
        #endif
        
        return headers
    }
}
