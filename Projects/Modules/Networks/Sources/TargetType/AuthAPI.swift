//
//  AuthAPI.swift
//  Networks
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import Moya
                                                                                                                      
enum AuthAPI {
    case signup(request: SignupRequest)
}
                                                                                                                      
extension AuthAPI: TargetType {
    var baseURL: URL {
        return NetworkConfiguration.baseURL
    }
                                                                                                                      
    var path: String {
        switch self {
        case .signup:
            return "/api/v1/auth/signup"
        }
    }
                                                                                                                      
    var method: Moya.Method {
        switch self {
        case .signup:
            return .post
        }
    }
                                                                                                                      
    var task: Moya.Task {
        switch self {
        case .signup(let request):
            return .requestJSONEncodable(request)
        }
    }
                                                                                                                      
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
