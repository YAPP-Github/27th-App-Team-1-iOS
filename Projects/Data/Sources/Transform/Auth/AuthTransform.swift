//
//  AuthTransform.swift
//  Data
//
//  Created by kimnahun on 1/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation
import Networks

extension SignupResult {
    init(from response: SignupResponse) {
        self.init(
            uuid: response.uuid,
            accessToken: response.accessToken,
            nickname: response.nickname
        )
    }
}

extension SignupRequest {
    init(from info: SignupInfo) {
        self.init(fcmToken: info.fcmToken)
    }
}
