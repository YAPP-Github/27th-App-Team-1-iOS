//
//  PlaceDetailError.swift
//  Domain
//
//  Created by kimnahun on 2026-02-09.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

/// 장소 상세 조회 API 에러
public enum PlaceDetailError: Error, Sendable {
    /// 필수 요청 파라미터가 존재하지 않음 (COMM-01-006)
    case missingParameter(message: String)
    /// 장소를 찾을 수 없음 (PLACE-02-001)
    case notFound(message: String)
    /// 알 수 없는 에러
    case unknown(code: String, message: String)
}
