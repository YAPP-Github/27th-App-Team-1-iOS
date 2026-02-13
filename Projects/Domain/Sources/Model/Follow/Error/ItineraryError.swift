//
//  ItineraryError.swift
//  Domain
//
//  Created by kimnahun on 2026-02-09.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

/// 여행 템플릿 일정 조회 API 에러
public enum ItineraryError: Error, Sendable {
    /// 여행 템플릿을 찾을 수 없음 (TRAVEL-02-001)
    case notFound(message: String)
    /// 서버 에러 (COMM-08-001)
    case serverError(message: String)
    /// 알 수 없는 에러
    case unknown(code: String, message: String)
}
