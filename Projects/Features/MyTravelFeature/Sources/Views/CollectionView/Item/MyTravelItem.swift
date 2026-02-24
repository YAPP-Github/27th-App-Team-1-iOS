//
//  MyTravelItem.swift
//  MyTravelFeature
//
//  Created by 최안용 on 2/23/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

enum MyTravelItem: Hashable {
    case banner(MyTravelPresentationModel.Banner)
    case upcomingList(MyTravelPresentationModel.Upcoming)
    case recommendTrip(MyTravelPresentationModel.RecommendedTrip)
}
