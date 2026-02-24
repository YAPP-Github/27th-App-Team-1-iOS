//
//  Date+.swift
//  Core
//
//  Created by 최안용 on 2/22/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public extension Date {
    func toKoreanMMdd() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: self)
    }
}
