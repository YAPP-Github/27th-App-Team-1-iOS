//
//  TripResponse.swift
//  Networks
//
//  Created by 최안용 on 2/9/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct TripResponse: Decodable {
    public let content: [TripContentResponse]
    public let hasNext: Bool
}

public struct TripContentResponse: Decodable {
    public let id: Int
    public let title: String
    public let thumbnail: String?
    public let programName: String
    public let traveler: String
    public let country: String
    public let city: String
    public let nights: Int
    public let days: Int
}
