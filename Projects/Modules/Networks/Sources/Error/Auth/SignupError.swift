//
//  SignupError.swift
//  Networks
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation


public enum SignupField {
    case fcmToken
    case unknown(String)

    public init(rawValue: String) {
        switch rawValue {
        case "fcmToken":    self = .fcmToken
        default:            self = .unknown(rawValue)
        }
    }
}

// MARK: - Error
public struct SignupError: APIErrorProtocol {
    public let type: ErrorType
    public let message: String
    public let field: SignupField?
    public let fieldMessage: String?

    public enum ErrorType {
        case validationError
        case internalServerError
        case undefined(code: String)
    }

    public init(code: String, message: String, errors: [ErrorResponse.ErrorDetail]) {
        self.message = message

        if let firstError = errors.first {
            self.field = SignupField(rawValue: firstError.field ?? "")
            self.fieldMessage = firstError.message
        } else {
            self.field = nil
            self.fieldMessage = nil
        }

        switch code {
        case "COMM-01-005": self.type = .validationError
        case "COMM-08-001": self.type = .internalServerError
        default:            self.type = .undefined(code: code)
        }
    }
}
