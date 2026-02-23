//
//  HomeSectionKind.swift
//  HomeFeature
//
//  Created by 최안용 on 1/30/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Core

enum HomeSectionKind: Int, CaseIterable {
    case banner
    case category
    case popularTrip
    case recommendedTrip
    
    var headerTitle: String {
        switch self {
        case .category:
            return "인기 여행 따라가기"
        case .recommendedTrip:
            let nickname = UserManager.shared.nickname ?? "알 수 없음"
            return "\(nickname)님께 추천하는\n따라가기 여행 콘텐츠에요!"
        default: return ""
        }
    }
}
