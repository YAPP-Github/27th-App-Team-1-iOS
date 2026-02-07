//
//  CreateTravelError+Mapping.swift
//  Networks
//
//  Created by NDGL on 2026-02-06.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation

extension CreateTravelError {
    public init(code: String, message: String, errors: [ErrorResponse.ErrorDetail]) {
        switch code {
        case "COMM-01-005":
            // 유효성 검증 실패
            let fieldMessage = errors.first?.message ?? message
            let field = CreateTravelField(rawValue: errors.first?.field)
            self = .validationFailed(field: field, message: fieldMessage)

        case "TRAVEL-04-001":
            // 여행 종료일이 시작일보다 앞설 수 없음
            self = .invalidDateOrder(message: message)

        case "TRAVEL-02-001":
            // 여행 템플릿을 찾을 수 없음
            self = .notFoundTemplate(message: message)

        default:
            self = .unknown(code: code, message: message)
        }
    }
}

extension CreateTravelField {
    public init(rawValue: String?) {
        guard let rawValue = rawValue else {
            self = .unknown("unknown")
            return
        }
        switch rawValue {
        case "templateId": self = .templateId
        case "startDate": self = .startDate
        case "endDate": self = .endDate
        default: self = .unknown(rawValue)
        }
    }
}
