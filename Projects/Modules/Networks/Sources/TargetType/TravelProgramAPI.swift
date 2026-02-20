//
//  TravelProgramAPI.swift
//  Networks
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Moya

public enum TravelProgramAPI {
    case getTravelPrograms
}

extension TravelProgramAPI: TargetType {
    public var baseURL: URL {
        NetworkConfiguration.baseURL
    }
    
    public var path: String {
        switch self {
        case .getTravelPrograms:
            return "/api/v1/travel-programs"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getTravelPrograms:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getTravelPrograms:
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
