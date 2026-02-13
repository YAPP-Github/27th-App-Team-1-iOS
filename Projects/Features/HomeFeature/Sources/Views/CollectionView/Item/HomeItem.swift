//
//  HomeItem.swift
//  HomeFeature
//
//  Created by 최안용 on 2/4/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

enum HomeItem: Hashable {
    case banner(HomePresentationModel.Banner)
    case category(HomePresentationModel.Category, isSelected: Bool)
    case popularTrip(HomePresentationModel.PopularTrip)
    case recommendedTrip(HomePresentationModel.RecommendedTrip)
}
