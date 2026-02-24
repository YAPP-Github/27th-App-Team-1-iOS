//
//  GooglePlacesService.swift
//  Networks
//
//  Created by kimnahun on 2026-02-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import Moya

public protocol GooglePlacesServiceProtocol {
    func searchText(keyword: String) async throws -> GooglePlacesSearchResponse
}

public final class GooglePlacesService: GooglePlacesServiceProtocol {
    private let provider: MoyaProvider<GooglePlacesAPI>

    public init(provider: MoyaProvider<GooglePlacesAPI> = MoyaProvider<GooglePlacesAPI>()) {
        self.provider = provider
    }

    public func searchText(keyword: String) async throws -> GooglePlacesSearchResponse {
        try await provider.asyncThrowsRequestRaw(.searchText(keyword: keyword))
    }
}
