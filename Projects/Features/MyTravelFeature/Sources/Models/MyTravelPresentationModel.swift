//
//  MyTravelPresentationModel.swift
//  MyTravelFeature
//
//  Created by 최안용 on 2/22/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Core
import Domain

struct MyTravelPresentationModel {
    let banner: MyTravelPresentationModel.Banner
    let recommendedTrips: [MyTravelPresentationModel.RecommendedTrip]
    let upcomingList: [MyTravelPresentationModel.Upcoming]
    
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
    
    struct RecommendedTrip: Hashable {
        let id: Int
        let title: String
        let thumbnailUrl: String
        let creator: String
        let country: String
        let schedule: String
        let city: String
    }
    
    struct Upcoming: Hashable {
        let id: Int
        let title: String
        let profileImage: String
        let dDay: Int
        let duration: String
    }
}

extension MyTravelPresentationModel.Schedule {
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

extension MyTravelPresentationModel.Banner {
    static var empty: Self {
        return .init(
            id: 0,
            title: "",
            startDay: .now,
            endDay: .now,
            duration: "",
            tripSchedule: .empty
        )
    }
}

extension MyTripSummary {
    func toMyTravelModel() -> MyTravelPresentationModel.Banner {
        let schedule: MyTravelPresentationModel.Schedule
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
        
        return MyTravelPresentationModel.Banner(
            id: self.id,
            title: self.title,
            startDay: self.startDay,
            endDay: self.endDay,
            duration: "\(self.startDay.toKoreanMMdd())~\(self.endDay.toKoreanMMdd())",
            tripSchedule: schedule
        )
    }
}

extension TripInfo {
    func toRecommendMyTravelModel() -> MyTravelPresentationModel.RecommendedTrip {
        return MyTravelPresentationModel.RecommendedTrip(
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

extension UpcomingInfo {
    func toMyTravelModel() -> MyTravelPresentationModel.Upcoming {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTravel = calendar.startOfDay(for: self.startDate)
        let dDayValue = calendar.dateComponents([.day], from: startOfToday, to: startOfTravel).day ?? 0
        
        return MyTravelPresentationModel.Upcoming(
            id: self.id,
            title: self.title,
            profileImage: self.thumbnail ?? "",
            dDay: dDayValue,
            duration: "\(self.startDate.toKoreanMMdd())~\(self.endDate.toKoreanMMdd())"
        )
    }
}
