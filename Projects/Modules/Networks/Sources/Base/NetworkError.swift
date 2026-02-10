//
//  NetworkError.swift
//  Networks
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public enum NetworkError: Error, Sendable {
    case connectionFailed
    case decodingFailed
    case noData
    case unknown(String)

    public var message: String {
        switch self {
        case .connectionFailed:
            return "네트워크 연결을 확인해주세요"
        case .decodingFailed:
            return "데이터 처리 중 오류가 발생했습니다"
        case .noData:
            return "응답 데이터가 없습니다."
        case .unknown(let description):
            return "알 수 없는 오류: \(description)"
        }
    }
}  
