//
//  TravelProgramServiceFactory.swift
//  Data
//
//  Created by 최안용 on 2/15/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

public func makeTravelProgramService() -> TravelProgramServiceProtocol {
    return TravelProgramService()
}
