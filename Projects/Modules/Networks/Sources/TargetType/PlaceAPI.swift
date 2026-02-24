//
//  PlaceAPI.swift
//  Networks
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Moya

public enum PlaceAPI {
    case registerPlace(googlePlaceId: String)
    case getPlacePhotos(googlePlaceId: String)
    case getPlaceDetails(googlePlaceId: String)
}

extension PlaceAPI: TargetType {
    public var baseURL: URL {
        NetworkConfiguration.baseURL
    }
    
    public var path: String {
        switch self {
        case .registerPlace:
            return "/api/v1/places"
        case .getPlacePhotos:
            return "/api/v1/places/photos"
        case .getPlaceDetails:
            return "/api/v1/places/detail"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .registerPlace:
            return .post
        case .getPlacePhotos, .getPlaceDetails:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .registerPlace(let googlePlaceId):
            let body = ["googlePlaceId": googlePlaceId]
            let data = (try? JSONSerialization.data(withJSONObject: body)) ?? Data()
            return .requestData(data)
        case .getPlacePhotos(let googlePlaceId), .getPlaceDetails(let googlePlaceId):
            return .requestParameters(
                parameters:  ["googlePlaceId": googlePlaceId],
                encoding: URLEncoding.queryString
            )
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
