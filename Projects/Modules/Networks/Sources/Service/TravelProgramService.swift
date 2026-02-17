//
//  TravelProgramService.swift
//  Networks
//
//  Created by 최안용 on 2/14/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Moya

public protocol TravelProgramServiceProtocol {
    func getTravelPrograms() async throws -> [ProgramResponse]
}

public final class TravelProgramService: TravelProgramServiceProtocol {
    private let provider: MoyaProvider<TravelProgramAPI>
    
    public init(provider: MoyaProvider<TravelProgramAPI> = MoyaProvider<TravelProgramAPI>()) {
        self.provider = provider
    }
    
    public func getTravelPrograms() async throws -> [ProgramResponse] {
        try await provider.asyncThowsRequest(.getTravelPrograms)
    }
}
