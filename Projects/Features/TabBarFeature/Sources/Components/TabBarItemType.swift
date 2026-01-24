//
//  TabBarItemType.swift
//  TabBarFeature
//
//  Created by 최안용 on 1/23/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

enum TabBarItemType: Int, CaseIterable {
    case information = 0
    case home
    case myTrip
    
    var title: String {
        switch self {
        case .information:
            return "정보"
        case .home:
            return "홈"
        case .myTrip:
            return "내 여행"
        }
    }
    
    var image: UIImage {
        let asset: DSKitImages
        switch self {
        case .information:
            asset = DSKitAsset.Assets.icFileText
        case .home:
            asset = DSKitAsset.Assets.icHome3
        case .myTrip:
            asset = DSKitAsset.Assets.icBag1
        }
        return asset.image.withRenderingMode(.alwaysTemplate)
    }
}

