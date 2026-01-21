//
//  MyTrip.swift
//  Domain
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

/// 내가 등록한 여행지
public struct MyTrip: Equatable {
    public let id: Int
    public let title: String
    public let destination: String
    public let startDate: Date
    public let endDate: Date
    public let thumbnailURL: String?

    public init(
        id: Int,
        title: String,
        destination: String,
        startDate: Date,
        endDate: Date,
        thumbnailURL: String?
    ) {
        self.id = id
        self.title = title
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.thumbnailURL = thumbnailURL
    }
}
