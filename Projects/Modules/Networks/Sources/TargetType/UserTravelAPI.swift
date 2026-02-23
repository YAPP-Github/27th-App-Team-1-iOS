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
    case getContentCard(id: Int)
    case getUpcoming
    case getUpcomingList(page: Int?, size: Int?)
}

extension UserTravelAPI: TargetType {
    public var baseURL: URL {
        NetworkConfiguration.baseURL
    }
    
    public var path: String {
        switch self {
        case .createUserTravel:
            return "/api/v1/travels"
        case .getContentCard(id: let id):
            return "/api/v1/travels/\(id)/content-card"
        case .getUpcoming:
            return "/api/v1/travels/upcoming"
        case .getUpcomingList:
            return "api/v1/travels/upcoming/list"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .createUserTravel:
            return .post
        case .getContentCard, .getUpcoming, .getUpcomingList:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .createUserTravel(let request):
            return .requestJSONEncodable(request)
        case .getContentCard, .getUpcoming:
            return .requestPlain
        case .getUpcomingList(let page, let size):
            var params: [String: Any] = [:]
            
            if let page { params["page"] = page }
            if let size { params["size"] = size }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
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
