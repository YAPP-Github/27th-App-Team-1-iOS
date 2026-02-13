//
//  PopularTravelItem.swift
//  PopularTravelFeature
//
//  Created by 최안용 on 2/12/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

enum PopularTravelItem: Hashable {
    case category(PopularTravelPresentationModel.Category, isSelected: Bool)
    case popularTrip(PopularTravelPresentationModel.PopularTrip)
}
