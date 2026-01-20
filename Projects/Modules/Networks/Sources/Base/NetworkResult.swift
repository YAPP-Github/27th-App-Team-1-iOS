//
//  NetworkResult.swift
//  Networks
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

@frozen
public enum NetworkResult<T: Sendable, E: Error & Sendable>: Sendable {
    case success(T)
    case failure(E)
    case networkFailure(NetworkError)
}
