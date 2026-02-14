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
    case searchPlaces // 아직 적용x
    case getPlacePhotos(googlePlaceId: String)
    case getPlaceDetails(googlePlaceId: String)
}

extension PlaceAPI: TargetType {
    public var baseURL: URL {
        NetworkConfiguration.baseURL
    }
    
    public var path: String {
        switch self {
        case .searchPlaces:
            return "/api/v1/places"
        case .getPlacePhotos:
            return "/api/v1/places/photos"
        case .getPlaceDetails:
            return "/api/v1/places/detail"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .searchPlaces:
            return .post
        case .getPlacePhotos, .getPlaceDetails:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .searchPlaces:
            return .requestPlain
        case .getPlacePhotos(let googlePlaceId), .getPlaceDetails(let googlePlaceId):
            return .requestParameters(
                parameters:  ["googlePlaceId": googlePlaceId],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    public var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
}
