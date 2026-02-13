//
//  NDGLError.swift
//  Domain
//
//  Created by 최안용 on 2/13/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public enum NDGLError: Error {
    case serverError(String)
    case unknown(String)
    case authenticationFailed
}
