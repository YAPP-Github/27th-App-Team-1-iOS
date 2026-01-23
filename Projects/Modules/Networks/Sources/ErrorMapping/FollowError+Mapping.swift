//
//  FollowError+Mapping.swift
//  Networks
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation

extension FollowError {
    public init(code: String, message: String, errors: [ErrorResponse.ErrorDetail]) {
        switch code {
        case "TRAVEL-02-001":
            self = .notFound(message: message)
        case "COMM-08-001":
            self = .serverError(message: message)
        default:
            self = .unknown(code: code, message: message)
        }
    }
}
