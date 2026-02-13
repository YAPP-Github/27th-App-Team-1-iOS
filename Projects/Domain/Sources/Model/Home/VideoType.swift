//
//  VideoType.swift
//  Domain
//
//  Created by 최안용 on 2/10/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public enum VideoType: String {
    case youtube = "YOUTUBE"
    case tv = "TV"
    case none
    
    public init(rawValue: String) {
        switch rawValue {
        case "YOUTUBE":
            self = .youtube
        case "TV":
            self = .tv
        default:
            self = .none
        }
    }
}
