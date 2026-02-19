//
//  TemplatesSearchUsecase.swift
//  Domain
//
//  Created by 최안용 on 2/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public protocol TemplatesSearchUsecaseProtocol {
    func searchTemplate(keyword: String, page: Int?, size: Int?) async throws -> [TripInfo]
}

public extension TemplatesSearchUsecaseProtocol {
    func searchTemplate(
        keyword: String,
        page: Int? = nil,
        size: Int? = nil
    ) async throws -> [TripInfo] {
        try await self.searchTemplate(keyword: keyword, page: page, size: size)
    }
}

public final class TemplatesSearchUsecase {
    private let travelTemplateRepository: TravelTemplateRepositoryInterface
    
    public init(travelTemplateRepository: TravelTemplateRepositoryInterface) {
        self.travelTemplateRepository = travelTemplateRepository
    }
}

extension TemplatesSearchUsecase: TemplatesSearchUsecaseProtocol {
    public func searchTemplate(keyword: String, page: Int?, size: Int?) async throws -> [TripInfo] {
        try await travelTemplateRepository.searchTemplate(keyword: keyword, page: page, size: size)
    }
}
