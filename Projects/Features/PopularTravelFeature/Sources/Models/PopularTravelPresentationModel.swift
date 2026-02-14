//
//  PopularTravelPresentationModel.swift
//  PopularTravelFeature
//
//  Created by 최안용 on 2/12/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain

struct PopularTravelPresentationModel {
    let category: [PopularTravelPresentationModel.Category]
    let popularTrip: [PopularTravelPresentationModel.PopularTrip]
    
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
}

extension TripCategory {
    func toPopularTravelModel() -> PopularTravelPresentationModel.Category {
        return PopularTravelPresentationModel.Category(
            id: self.id,
            creator: self.creator,
            viedoType: self.viedoType
        )
    }
}

extension TripInfo {
    func toPopularTravelModel() -> PopularTravelPresentationModel.PopularTrip {
        return PopularTravelPresentationModel.PopularTrip(
            id: self.id,
            title: self.title,
            thumbnailUrl: self.thumbnailUrl,
            creator: self.creator,
            schedule: "\(self.nights)박 \(self.days)일",
            country: self.country,
            city: self.city
        )
    }
}
