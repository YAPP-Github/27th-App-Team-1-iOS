//
//  TabBarInteractor.swift
//  TabBarFeature
//
//  Created by kimnahun on 2026-01-22.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs
import RxSwift

// MARK: - TabBarListener

public protocol TabBarListener: AnyObject {
    // 부모 RIB에 전달할 이벤트 정의
}

// MARK: - TabBarPresentable

protocol TabBarPresentable: Presentable {
    var listener: TabBarPresentableListener? { get set }
}

// MARK: - TabBarInteractor

final class TabBarInteractor: PresentableInteractor<TabBarPresentable>, TabBarInteractable {

    weak var router: TabBarRouting?
    weak var listener: TabBarListener?

    private let disposeBag = DisposeBag()

    override init(presenter: TabBarPresentable) {
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

// MARK: - TabBarPresentableListener

extension TabBarInteractor: TabBarPresentableListener {
    // ViewController에서 Interactor로 전달하는 이벤트 처리
}
