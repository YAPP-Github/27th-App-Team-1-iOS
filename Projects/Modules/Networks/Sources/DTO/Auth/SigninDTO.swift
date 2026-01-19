//
//  Signin.swift
//  Networks
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
                                                                                                   
struct SignupRequest: Encodable {
    let fcmToken: String
    let deviceModel: String?
    let deviceOs: String?
    let deviceOsVersion: String?
    let appVersion: String?
}

struct SignupResponse: Decodable {
    let uuid: String
    let accessToken: String
    let nickname: String
}
