//
//  SignupError+Mapping.swift
//  Networks
//
//  Created by kimnahun on 1/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation

extension SignupError {
    public init(code: String, message: String, errors: [ErrorResponse.ErrorDetail]) {
        let fieldMessage = errors.first?.message ?? message

        let field: SignupField = {
            guard let fieldString = errors.first?.field else {
                return .unknown("unknown")
            }
            switch fieldString {
            case "fcmToken": return .fcmToken
            case "email":    return .email
            default:         return .unknown(fieldString)
            }
        }()

        switch code {
        case "COMM-01-005":
            self = .validationFailed(field: field, message: fieldMessage)
        case "AUTH-01-001":
            self = .userAlreadyExists
        case "COMM-08-001":
            self = .serverError(message: message)
        default:
            self = .unknown(code: code, message: message)
        }
    }
}

extension SignupField {
    public init(rawValue: String) {
        switch rawValue {
        case "fcmToken": self = .fcmToken
        case "email":    self = .email
        default:         self = .unknown(rawValue)
        }
    }
}
