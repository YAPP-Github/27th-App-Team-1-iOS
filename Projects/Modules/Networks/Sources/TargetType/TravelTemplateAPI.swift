//
//  TravelTemplateAPI.swift
//  Networks
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Moya

public enum TravelTemplateAPI {
    case getItinerary(id: Int, day: Int?)
    case getContentCard(id: Int)
    case searchTemplate(keyword: String, page: Int?, size: Int?)
    case getPopularTripList(id: Int?, page: Int?, size: Int?)
    case getRecommendTripList(page: Int?, size: Int?)
}

extension TravelTemplateAPI: TargetType {
    public var baseURL: URL {
        NetworkConfiguration.baseURL
    }
    
    public var path: String {
        switch self {
        case .getItinerary(let id, _):
            return "/api/v1/travel-templates/\(id)/itinerary"
        case .getContentCard(let id):
            return "/api/v1/travel-templates/\(id)/content-card"
        case .searchTemplate:
            return "/api/v1/travel-templates/search"
        case .getPopularTripList:
            return "/api/v1/travel-templates/popular"
        case .getRecommendTripList:
            return "/api/v1/travel-templates/recommend"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getItinerary, .getContentCard, .searchTemplate, .getPopularTripList, .getRecommendTripList:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getItinerary(_, let day):
            if let day = day {
                return .requestParameters(
                    parameters: ["day": day],
                    encoding: URLEncoding.queryString
                )
            }
            return .requestPlain
        case .getContentCard(let id):
            return .requestPlain
        case .searchTemplate(let keyword, let page, let size):
            var params: [String: Any] = [:]
            
            params["keyword"] = keyword
            
            if let page { params["page"] = page }
            if let size { params["size"] = size }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
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
        [
            "Content-Type": "application/json",
            "X-API-KEY":
                "ndgl_ios_7d61390564126f8e66deea15e20bb126c3be9190d9faf9d7c84fbe04ff544d4a"
        ]
    }
}
