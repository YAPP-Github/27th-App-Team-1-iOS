//
//  FollowDetailInteractor.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs
import RxSwift

// MARK: - FollowDetailListener

public protocol FollowDetailListener: AnyObject {
    func followDetailDidTapClose()
}

// MARK: - FollowDetailPresentable

protocol FollowDetailPresentable: Presentable {
    var listener: FollowDetailPresentableListener? { get set }
}

// MARK: - FollowDetailPresentableListener

protocol FollowDetailPresentableListener: AnyObject {
    func didTapCloseButton()
}

// MARK: - FollowDetailInteractor

final class FollowDetailInteractor: PresentableInteractor<FollowDetailPresentable>, FollowDetailInteractable {

    weak var router: FollowDetailRouting?
    weak var listener: FollowDetailListener?

    private let disposeBag = DisposeBag()
    private let recommendationId: Int

    init(presenter: FollowDetailPresentable, recommendationId: Int) {
        self.recommendationId = recommendationId
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: recommendationId를 사용하여 데이터 로드
        print("FollowDetail loaded with recommendationId: \(recommendationId)")
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - FollowDetailPresentableListener

extension FollowDetailInteractor: FollowDetailPresentableListener {
    func didTapCloseButton() {
        listener?.followDetailDidTapClose()
    }
}
