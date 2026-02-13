//
//  PlacePhotosError+Mapping.swift
//  Networks
//
//  Created by kimnahun on 2026-02-09.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation

extension PlacePhotosError {
    public init(code: String, message: String, errors: [ErrorResponse.ErrorDetail]) {
        switch code {
        case "COMM-01-006":
            self = .missingParameter(message: message)
        case "COMM-08-001":
            self = .serverError(message: message)
        case "GMAP_PLACE-07-001":
            self = .googleApiError(message: message)
        default:
            self = .unknown(code: code, message: message)
        }
    }
}
