//
//  FollowAPI.swift
//  Networks
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Alamofire
import Foundation
import Moya

public enum FollowAPI {
    /// 여행 템플릿 상세 조회
    case getContentCard(id: Int)
    /// 여행 템플릿 일정 조회
    case getItinerary(id: Int, day: Int?)
    /// 장소 상세 조회
    case getPlaceDetail(googlePlaceId: String)
    /// 장소 사진 조회
    case getPlacePhotos(googlePlaceId: String)
}

extension FollowAPI: TargetType {
    public var baseURL: URL {
        NetworkConfiguration.baseURL
    }

    public var path: String {
        switch self {
        case .getContentCard(let id):
            return "/api/v1/travel-templates/\(id)/content-card"
        case .getItinerary(let id, _):
            return "/api/v1/travel-templates/\(id)/itinerary"
        case .getPlaceDetail:
            return "/api/v1/places/detail"
        case .getPlacePhotos:
            return "/api/v1/places/photos"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getContentCard, .getItinerary, .getPlaceDetail, .getPlacePhotos:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case .getContentCard:
            return .requestPlain
        case .getItinerary(_, let day):
            if let day = day {
                return .requestParameters(
                    parameters: ["day": day],
                    encoding: URLEncoding.queryString
                )
            }
            return .requestPlain
        case .getPlaceDetail(let googlePlaceId):
            return .requestParameters(
                parameters: ["googlePlaceId": googlePlaceId],
                encoding: URLEncoding.queryString
            )
        case .getPlacePhotos(let googlePlaceId):
            return .requestParameters(
                parameters: ["googlePlaceId": googlePlaceId],
                encoding: URLEncoding.queryString
            )
        }
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
