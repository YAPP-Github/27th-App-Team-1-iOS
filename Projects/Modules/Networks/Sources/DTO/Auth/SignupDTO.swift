//
//  Signin.swift
//  Networks
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
                                                                                                   
public struct SignupRequest: Encodable {
    public let fcmToken: String
    public let deviceModel: String?
    public let deviceOs: String?
    public let deviceOsVersion: String?
    public let appVersion: String?

    public init(
        fcmToken: String,
        deviceModel: String? = nil,
        deviceOs: String? = nil,
        deviceOsVersion: String? = nil,
        appVersion: String? = nil
    ) {
        self.fcmToken = fcmToken
        self.deviceModel = deviceModel
        self.deviceOs = deviceOs
        self.deviceOsVersion = deviceOsVersion
        self.appVersion = appVersion
    }
}

public struct SignupResponse: Decodable {
    public let uuid: String
    public let accessToken: String
    public let nickname: String
}
