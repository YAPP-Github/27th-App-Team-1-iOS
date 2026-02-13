//
//  Error+.swift
//  Data
//
//  Created by 최안용 on 2/13/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension Error {
    func toNDGLError() -> NDGLError {
        if let networkError = self as? NetworkError {
            switch networkError {
            case .connectionFailed, .decodingFailed, .noData:
                return .unknown("\(networkError.message)")
            case .unknown(let string):
                return .serverError(string)
            case .serverError(let errorResponse):
                return .serverError(errorResponse.message ?? "알 수 없는 오류가 발생했습니다.")
            }
        }
        
        return .unknown("알 수 없는 오류가 발생했습니다.")
    }
}
