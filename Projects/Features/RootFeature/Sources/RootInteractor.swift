//
//  RootInteractor.swift
//  RootFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs
import RxSwift

// MARK: - RootListener

public protocol RootListener: AnyObject {
    // Root는 최상위 RIB이므로 Listener가 없음
}

// MARK: - RootPresentable

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
}

// MARK: - RootInteractor

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable {

    weak var router: RootRouting?
    weak var listener: RootListener?

    private let disposeBag = DisposeBag()

    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - RootPresentableListener

extension RootInteractor: RootPresentableListener {
    // ViewController에서 Interactor로 전달하는 이벤트 처리
}
