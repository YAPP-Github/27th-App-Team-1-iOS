//
//  PlaceDetailError+Mapping.swift
//  Networks
//
//  Created by kimnahun on 2026-02-09.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation

extension PlaceDetailError {
    public init(code: String, message: String, errors: [ErrorResponse.ErrorDetail]) {
        switch code {
        case "COMM-01-006":
            self = .missingParameter(message: message)
        case "PLACE-02-001":
            self = .notFound(message: message)
        default:
            self = .unknown(code: code, message: message)
        }
    }
}
