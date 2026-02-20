//
//  SearchResultPresentationModel.swift
//  SearchFeature
//
//  Created by 최안용 on 2/18/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain

struct SearchResultPresentationModel {
    let resultTrip: [SearchResultPresentationModel.ResultTrip]
    
    struct ResultTrip: Hashable {
        let id: Int
        let title: String
        let thumbnailUrl: String
        let creator: String
        let schedule: String
        let country: String
        let city: String
    }
}

extension TripInfo {
    func toSearchResultModel() -> SearchResultPresentationModel.ResultTrip {
        return SearchResultPresentationModel.ResultTrip(
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
