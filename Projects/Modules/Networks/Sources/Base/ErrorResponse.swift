//
//  ErrorResponse.swift
//  Networks
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
                                                                                                                      
struct ErrorResponse: Decodable {
    let code: String?
    let message: String?
    let errors: [ErrorDetail]?
                                                                                                                      
    struct ErrorDetail: Decodable {
        let field: String?
        let message: String?
    }
}   
