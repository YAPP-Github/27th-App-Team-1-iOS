//
//  MyTravelSectionKind.swift
//  MyTravelFeature
//
//  Created by 최안용 on 2/22/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

enum MyTravelSectionKind: Hashable {
    case banner
    case upcomingTrips(isEmpty: Bool)
    case recommendedTrip
    
    var headerTitle: String {
        switch self {
        case .upcomingTrips:
            return "다가오는 여행"
        case .recommendedTrip:
            return "추천하는 따라가기 여행"
        default: return ""
        }
    }
}
