//
//  PlacePhotosError.swift
//  Domain
//
//  Created by kimnahun on 2026-02-09.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

/// 장소 사진 조회 API 에러
public enum PlacePhotosError: Error, Sendable {
    /// 필수 요청 파라미터가 존재하지 않음 (COMM-01-006)
    case missingParameter(message: String)
    /// 서버 에러 (COMM-08-001)
    case serverError(message: String)
    /// Google Maps Places API 호출 실패 (GMAP_PLACE-07-001)
    case googleApiError(message: String)
    /// 알 수 없는 에러
    case unknown(code: String, message: String)
}
