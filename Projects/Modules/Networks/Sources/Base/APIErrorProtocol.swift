//
//  APIErrorProtocol.swift
//  Networks
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//
                                                                                  
import Foundation
                                                                                                                      
public protocol APIErrorProtocol: Error {
    var message: String { get }

    init(code: String, message: String, errors: [ErrorResponse.ErrorDetail])
}
