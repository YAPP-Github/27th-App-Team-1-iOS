//
//  CreateTravelRequest.swift
//  Domain
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct CreateTravelRequest: Sendable {
    public let templateId: Int
    public let startDate: Date
    public let endDate: Date

    public init(templateId: Int, startDate: Date, endDate: Date) {
        self.templateId = templateId
        self.startDate = startDate
        self.endDate = endDate
    }
}
