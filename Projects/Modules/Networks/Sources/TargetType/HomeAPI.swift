//
//  HomeAPI.swift
//  Networks
//
//  Created by 최안용 on 2/4/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Moya

// MARK: - API 나오기 전 임시
public enum HomeAPI {
    case getMyTrip
    case getCategoryList
    case getPopularTripList(id: Int?, page: Int?, size: Int?)
    case getRecommendTripList(page: Int?, size: Int?)
}

extension HomeAPI: TargetType {
    public var baseURL: URL {
        NetworkConfiguration.baseURL
    }

    public var path: String {
        switch self {
        case .getMyTrip:
            return ""
        case .getCategoryList:
            return "/api/v1/travel-programs"
        case .getPopularTripList:
            return "/api/v1/travel-templates/popular"
        case .getRecommendTripList:
            return "/api/v1/travel-templates/recommend"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getMyTrip, .getCategoryList, .getPopularTripList, .getRecommendTripList:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case .getMyTrip, .getCategoryList:
            return .requestPlain
        case .getPopularTripList(let id, let page, let size):
            var params: [String: Any] = [:]
            
            if let id { params["travelProgramId"] = id }
            if let page { params["page"] = page }
            if let size { params["size"] = size }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case .getRecommendTripList(let page, let size):
            var params: [String: Any] = [:]
            
            if let page { params["page"] = page }
            if let size { params["size"] = size }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}

