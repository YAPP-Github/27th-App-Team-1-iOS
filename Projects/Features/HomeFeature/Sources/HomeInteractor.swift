//
//  HomeInteractor.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs
import RxSwift

// MARK: - HomeListener

public protocol HomeListener: AnyObject {
    // 부모 RIB에 전달할 이벤트 정의
}

// MARK: - HomePresentable

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
    // Interactor에서 ViewController로 전달할 메서드 정의
}

// MARK: - HomeInteractor

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable {

    weak var router: HomeRouting?
    weak var listener: HomeListener?

    private let disposeBag = DisposeBag()

    override init(presenter: HomePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // RIB이 활성화될 때 수행할 로직
    }

    override func willResignActive() {
        super.willResignActive()
        // RIB이 비활성화될 때 수행할 로직
    }
}

// MARK: - HomePresentableListener

extension HomeInteractor: HomePresentableListener {
    // ViewController에서 Interactor로 전달하는 이벤트 처리
}
