//
//  CreateTravelError.swift
//  Domain
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

// MARK: - CreateTravelField

public enum CreateTravelField: Sendable, Equatable {
    case templateId
    case startDate
    case endDate
    case unknown(String)
}

// MARK: - CreateTravelError

public enum CreateTravelError: Error, Sendable {
    /// 유효성 검증 실패 (COMM-01-005)
    case validationFailed(field: CreateTravelField, message: String)
    /// 여행 종료일이 시작일보다 앞설 수 없음 (TRAVEL-04-001)
    case invalidDateOrder(message: String)
    /// 여행 템플릿을 찾을 수 없음 (TRAVEL-02-001)
    case notFoundTemplate(message: String)
    /// 알 수 없는 에러
    case unknown(code: String, message: String)
}
