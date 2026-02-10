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
        let id = UUID()
        let title: String
        let startDay: Date
        let endDay: Date
        let tripSchedule: [Schedule]
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
        let id: String
        let title: String
        let thumbnailUrl: String
        let creator: String
        let schedule: String
        let country: String
        let city: String
    }
    
    struct RecommendedTrip: Hashable {
        let id: String
        let title: String
        let thumbnailUrl: String
        let creator: String
        let country: String
        let schedule: String
        let city: String
    }
}

extension MyTripSummary {
    func toPresention() -> HomePresentationModel.Banner {
        return HomePresentationModel.Banner(
            title: self.title,
            startDay: self.startDay,
            endDay: self.endDay,
            tripSchedule: self.tripSchedule.map {
                HomePresentationModel.Schedule(
                    id: $0.id,
                    day: $0.day,
                    placeName: $0.placeName,
                    thumbnailUrl: $0.thumbnailUrl,
                    transport: $0.transport,
                    estimatedDuration: $0.estimatedDuration
                )
            }
        )
    }
}

extension TripCategory {
    func toPresentaion() -> HomePresentationModel.Category {
        return HomePresentationModel.Category(
            id: self.id,
            creator: self.creator,
            viedoType: self.viedoType
        )
    }
}

extension TripInfo {
    func toPopularPresentaion() -> HomePresentationModel.PopularTrip {
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
    
    func toPresentaion() -> HomePresentationModel.RecommendedTrip {
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
