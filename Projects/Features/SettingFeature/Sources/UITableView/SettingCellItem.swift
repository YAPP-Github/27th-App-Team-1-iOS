//
//  SettingCellItem.swift
//  SettingFeature
//
//  Created by 최안용 on 2/11/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public enum SettingCellItem: Int, CaseIterable {
//    case notification
    case faq
    case recommendLink
    case identificationCode
    case terms
    case personalInformation
    case version
    
    var title: String {
        switch self {
//        case .notification: return "알림 설정"
        case .faq: return "FAQ"
        case .recommendLink: return "콘텐츠 추천 링크 넣기"
        case .identificationCode: return "내 식별코드"
        case .terms: return "서비스 약관"
        case .personalInformation: return "개인정보처리 방침"
        case .version: return "버전 정보"
        }
    }
    
    var cellType: SettingCellType {
        switch self {
//        case .notification:
//            return .toggle(isOn: true)
        case .version:
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
            return .detailText(text: version)
        default:
            return .icon
        }
    }
}
