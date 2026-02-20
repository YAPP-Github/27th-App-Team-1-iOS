//
//  AuthAPI.swift
//  Networks
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import Moya
                                                                                                                      
public enum AuthAPI {
    case signup(request: SignupRequest)
    case login(request: LoginRequest)
}

extension AuthAPI: TargetType {
    public var baseURL: URL {
        return NetworkConfiguration.baseURL
    }

    public var path: String {
        switch self {
        case .signup:
            return "/api/v1/auth/users"
        case .login:
            return "/api/v1/auth/login"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .signup, .login:
            return .post
        }
    }

    public var task: Moya.Task {
        switch self {
        case .signup(let request):
            return .requestJSONEncodable(request)
        case .login(let request):
            return .requestJSONEncodable(request)
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
