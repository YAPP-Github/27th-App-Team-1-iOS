//
//  MyTripSummary.swift
//  Domain
//
//  Created by 최안용 on 2/4/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

// MARK: - API 나오기 전 임시
public struct MyTripSummary {
    public let id: Int
    public let title: String
    public let startDay: Date
    public let endDay: Date
    public let tripSchedule: Schedule
    
    public init(id: Int, title: String, startDay: Date, endDay: Date, tripSchedule: Schedule) {
        self.id = id
        self.title = title
        self.startDay = startDay
        self.endDay = endDay
        self.tripSchedule = tripSchedule
    }
}

// MARK: - API 나오기 전 임시
public struct Schedule {
    public let id: Int
    public let day: Int
    public let placeName: String
    public let thumbnailUrl: String
    public let transport: String
    public let estimatedDuration: Int
    
    public init(
        id: Int,
        day: Int,
        placeName: String,
        thumbnailUrl: String,
        transport: String,
        estimatedDuration: Int
    ) {
        self.id = id
        self.day = day
        self.placeName = placeName
        self.thumbnailUrl = thumbnailUrl
        self.transport = transport
        self.estimatedDuration = estimatedDuration
    }
}
