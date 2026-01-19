//
//  AuthServiceTests.swift
//  NetworksTests
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import XCTest
@testable import Networks

final class AuthServiceTests: XCTestCase {

    var sut: AuthService!

    override func setUp() {
        super.setUp()
        sut = AuthService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Signup 실제 API 테스트
    func test_signup_실제API호출() async throws {
        // Given
        print("========== 테스트 시작 ==========")
        let request = SignupRequest(
            fcmToken: "test-fcm-token-12345",
            deviceModel: "iPhone",
            deviceOs: "iOS",
            deviceOsVersion: "17.0",
            appVersion: "1.0.0"
        )
        print("Request 생성 완료")

        // When
        print("API 호출 시작...")
        let result = await sut.signup(request: request)
        print("API 호출 완료")

        // Then
        switch result {
        case .success(let response):
            print("========== 성공 ==========")
            print("UUID: \(response.uuid)")
            print("AccessToken: \(response.accessToken)")
            print("Nickname: \(response.nickname)")
            print("==============================")
            XCTAssertFalse(response.uuid.isEmpty, "UUID가 비어있음")
            XCTAssertFalse(response.accessToken.isEmpty, "AccessToken이 비어있음")

        case .failure(let error):
            print("========== API 에러 ==========")
            print("Type: \(error.type)")
            print("Message: \(error.message)")
            if let field = error.field {
                print("Field: \(field)")
            }
            if let fieldMessage = error.fieldMessage {
                print("FieldMessage: \(fieldMessage)")
            }
            print("=================================")
            XCTAssertFalse(error.message.isEmpty, "에러 메시지가 비어있음")

        case .networkFailure(let error):
            print("==========네트워크 에러 ==========")
            print("Error: \(error.message)")
            print("=====================================")
            XCTFail("네트워크 연결 실패: \(error.message)")
        }

        print("========== 테스트 종료 ==========")
    }
}
