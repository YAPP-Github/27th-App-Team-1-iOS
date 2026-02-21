//
//  HomePresentationModel.swift
//  HomeFeature
//
//  Created by 최안용 on 2/4/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain

struct HomePresentationModel {
    let banner: HomePresentationModel.Banner
    let category: [HomePresentationModel.Category]
    let popularTrip: [HomePresentationModel.PopularTrip]
    let recommendedTrip: [HomePresentationModel.RecommendedTrip]
    
    struct Banner: Hashable {
        let id: Int
        let title: String
        let startDay: Date
        let endDay: Date
        let duration: String
        let tripSchedule: Schedule
    }
    
    struct Schedule: Hashable {
        let id: Int
        let day: Int
        let placeName: String
        let thumbnailUrl: String
        let transport: String
        let estimatedDuration: Int
    }
    
    struct Category: Hashable {
        let id: Int
        let creator: String
        let viedoType: VideoType
    }
    
    struct PopularTrip: Hashable {
        let id: Int
        let title: String
        let thumbnailUrl: String
        let creator: String
        let schedule: String
        let country: String
        let city: String
    }
    
    struct RecommendedTrip: Hashable {
        let id: Int
        let title: String
        let thumbnailUrl: String
        let creator: String
        let country: String
        let schedule: String
        let city: String
    }
}

extension HomePresentationModel.Banner {
    static var empty: Self {
        return .init(
            id: 0, // 0으로 설정하여 empty 배너임을 구분
            title: "다가오는 여행이 없습니다.",
            startDay: Date(),
            endDay: Date(),
            duration: "",
            tripSchedule: .empty
        )
    }
}

extension HomePresentationModel.Schedule {
    static var empty: Self {
        return .init(
            id: 0,
            day: 0,
            placeName: "",
            thumbnailUrl: "",
            transport: "",
            estimatedDuration: 0
        )
    }
}

extension MyTripSummary {
    func toPresention() -> HomePresentationModel.Banner {
        let schedule: HomePresentationModel.Schedule
        if let tripSchedule = self.tripSchedule {
            schedule = .init(
                id: tripSchedule.id,
                day: tripSchedule.day,
                placeName: tripSchedule.placeName,
                thumbnailUrl: tripSchedule.thumbnailUrl,
                transport: tripSchedule.transport,
                estimatedDuration: tripSchedule.estimatedDuration
            )
        } else {
            schedule = .empty
        }

        return HomePresentationModel.Banner(
            id: self.id,
            title: self.title,
            startDay: self.startDay,
            endDay: self.endDay,
            duration: "\(self.startDay.toKoreanMMdd())~\(self.endDay.toKoreanMMdd())",
            tripSchedule: schedule
        )
    }
}

extension TripCategory {
    func toHomeModel() -> HomePresentationModel.Category {
        return HomePresentationModel.Category(
            id: self.id,
            creator: self.creator,
            viedoType: self.viedoType
        )
    }
}

extension TripInfo {
    func toPopularHomeModel() -> HomePresentationModel.PopularTrip {
        return HomePresentationModel.PopularTrip(
            id: self.id,
            title: self.title,
            thumbnailUrl: self.thumbnailUrl,
            creator: self.creator,
            schedule: "\(self.nights)박 \(self.days)일",
            country: self.country,
            city: self.city
        )
    }
    
    func toRecommendHomeModel() -> HomePresentationModel.RecommendedTrip {
        return HomePresentationModel.RecommendedTrip(
            id: self.id,
            title: self.title,
            thumbnailUrl: self.thumbnailUrl,
            creator: self.creator,
            country: self.country,
            schedule: "\(self.nights)박 \(self.days)일",
            city: self.city
        )
    }
}

extension Date {
    func toKoreanMMdd() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: self)
    }
}
