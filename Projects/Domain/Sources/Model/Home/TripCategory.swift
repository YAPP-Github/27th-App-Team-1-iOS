//
//  TripCategory.swift
//  Domain
//
//  Created by 최안용 on 2/4/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct TripCategory {
    public let id: Int
    public let creator: String
    public let viedoType: VideoType
    
    public init(id: Int, creator: String, viedoType: VideoType) {
        self.id = id
        self.creator = creator
        self.viedoType = viedoType
    }
}
