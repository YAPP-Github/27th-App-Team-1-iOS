//
//  BaseResponse.swift
//  Networks
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
                                                                                                                      
struct BaseResponse<T: Decodable>: Decodable {
    let code: String
    let message: String
    let data: T?
} 
