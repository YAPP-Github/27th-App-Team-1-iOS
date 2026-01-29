//
//  FollowError.swift
//  Domain
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public enum FollowError: Error, Sendable {
    /// 여행 템플릿을 찾을 수 없음
    case notFound(message: String)
    /// 서버 에러
    case serverError(message: String)
    /// 네트워크 에러
    case networkError(message: String)
    /// 알 수 없는 에러
    case unknown(code: String, message: String)
}
