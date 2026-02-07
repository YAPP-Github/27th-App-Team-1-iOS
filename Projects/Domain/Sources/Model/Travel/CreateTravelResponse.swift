//
//  CreateTravelResponse.swift
//  Domain
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct CreateTravelResponse: Sendable {
    public let userTravelId: Int

    public init(userTravelId: Int) {
        self.userTravelId = userTravelId
    }
}
