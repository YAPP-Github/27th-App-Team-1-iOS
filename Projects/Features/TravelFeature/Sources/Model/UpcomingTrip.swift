//
//  UpcomingTrip.swift
//  TravelFeature
//
//  Created by kimnahun on 2026-01-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct UpcomingTrip: Hashable {
    public let id: Int
    public let title: String
    public let thumbnailURL: String?
    public let startDate: Date
    public let endDate: Date

    public init(
        id: Int,
        title: String,
        thumbnailURL: String?,
        startDate: Date,
        endDate: Date
    ) {
        self.id = id
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.startDate = startDate
        self.endDate = endDate
    }

    // D-day 계산
    public var dDay: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let start = calendar.startOfDay(for: startDate)
        let components = calendar.dateComponents([.day], from: today, to: start)
        return components.day ?? 0
    }

    // 날짜 범위 문자열
    public var dateRangeString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"

        let startString = formatter.string(from: startDate)
        let endString = formatter.string(from: endDate)

        return "\(startString)~\(endString)"
    }
}
