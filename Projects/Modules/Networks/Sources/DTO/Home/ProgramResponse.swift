//
//  ProgramResponse.swift
//  Networks
//
//  Created by 최안용 on 2/9/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct ProgramResponse: Decodable {
    public let id: Int
    public let name: String
    public let type: String
}
