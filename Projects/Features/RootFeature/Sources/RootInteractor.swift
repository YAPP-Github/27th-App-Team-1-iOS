//
//  RootInteractor.swift
//  RootFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Core
import Domain

import RIBs
import RxSwift

// MARK: - RootRouting

public protocol RootRouting: ViewableRouting {
    func attachMain()
    func detachMain()
}

// MARK: - RootPresentable

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
}

// MARK: - RootListener

public protocol RootListener: AnyObject {
    // Root는 최상위 RIB이므로 Listener가 없음
}

// MARK: - RootInteractor

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable {

    weak var router: RootRouting?
    weak var listener: RootListener?

    private let authRepository: AuthRepositoryInterface
    private let tokenRepository: TokenRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(
        presenter: RootPresentable,
        authRepository: AuthRepositoryInterface,
        tokenRepository: TokenRepositoryProtocol
    ) {
        self.authRepository = authRepository
        self.tokenRepository = tokenRepository
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        performAuthFlow()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    private func performAuthFlow() {
        Task { [weak self] in
            guard let self else { return }

            do {
                if let uuid = self.tokenRepository.get(.uuid) {
                    let loginResult = try await self.authRepository.login(uuid: uuid)
                    self.tokenRepository.save(loginResult.accessToken, for: .accessToken)
                    
                    UserManager.shared.uuid = loginResult.uuid
                    UserManager.shared.nickname = loginResult.nickname
                } else {
                    let fcmToken = self.tokenRepository.get(.fcmToken) ?? UUID().uuidString
                    let signupResult = try await self.authRepository.signup(
                        info: SignupInfo(fcmToken: fcmToken)
                    )
                    self.tokenRepository.save(signupResult.uuid, for: .uuid)
                    self.tokenRepository.save(signupResult.accessToken, for: .accessToken)
                    
                    UserManager.shared.uuid = signupResult.uuid
                    UserManager.shared.nickname = signupResult.nickname
                    
                    let loginResult = try await self.authRepository.login(uuid: signupResult.uuid)
                    self.tokenRepository.save(loginResult.accessToken, for: .accessToken)
                }

                await MainActor.run {
                    self.router?.attachMain()
                }
            } catch {
                print("[RootInteractor] Auth flow failed: \(error)")
            }
        }
    }
}

// MARK: - RootPresentableListener

extension RootInteractor: RootPresentableListener {
    // ViewController에서 Interactor로 전달하는 이벤트 처리
}
