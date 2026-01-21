//
//  ErrorResponse.swift
//  Networks
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
                                                                                                                      
public struct ErrorResponse: Decodable, Sendable {
    public let code: String?
    public let message: String?
    public let errors: [ErrorDetail]?

    public struct ErrorDetail: Decodable, Sendable {
        public let field: String?
        public let message: String?
    }
}   
