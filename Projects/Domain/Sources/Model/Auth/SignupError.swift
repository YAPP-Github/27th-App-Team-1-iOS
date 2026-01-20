//
//  SignupError.swift
//  Domain
//
//  Created by kimnahun on 1/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

// MARK: - SignupField

public enum SignupField: Sendable, Equatable {
    case fcmToken
    case email
    case unknown(String)
}

// MARK: - SignupError

public enum SignupError: Error, Sendable {
    case validationFailed(field: SignupField, message: String)
    case userAlreadyExists
    case serverError(message: String?)
    case networkError(message: String)
    case unknown(code: String, message: String)
}
