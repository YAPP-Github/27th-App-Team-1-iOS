//
//  SettingSection.swift
//  SettingFeature
//
//  Created by 최안용 on 2/10/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

enum SettingSection: Int, CaseIterable {
    case menu
    
    var items: [SettingCellItem] {
        switch self {
        case .menu: [.faq, .recommendLink, .identificationCode,.terms, .personalInformation, .version]
        }
    }
}
