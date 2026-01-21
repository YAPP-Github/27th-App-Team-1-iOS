//
//  SignupInfo.swift
//  Domain
//
//  Created by kimnahun on 1/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public struct SignupInfo: Sendable {
    public let fcmToken: String

    public init(fcmToken: String) {
        self.fcmToken = fcmToken
    }
}
