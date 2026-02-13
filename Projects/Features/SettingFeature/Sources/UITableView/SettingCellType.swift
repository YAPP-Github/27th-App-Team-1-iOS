//
//  SettingCellType.swift
//  SettingFeature
//
//  Created by 최안용 on 2/11/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

enum SettingCellType {
    case toggle(isOn: Bool)
    case icon
    case detailText(text: String)
    
    var cellHeight: CGFloat {
        switch self {
        case .toggle:
            return 63.adjustedH
        case .icon, .detailText:
            return 56.adjustedH
        }
    }
}
