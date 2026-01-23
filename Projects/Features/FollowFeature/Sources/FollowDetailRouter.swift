//
//  FollowDetailRouter.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

// MARK: - FollowDetailInteractable

protocol FollowDetailInteractable: Interactable {
    var router: FollowDetailRouting? { get set }
    var listener: FollowDetailListener? { get set }
}

// MARK: - FollowDetailViewControllable

public protocol FollowDetailViewControllable: ViewControllable {
    // ViewController에 요청할 화면 전환 메서드 정의
}

// MARK: - FollowDetailRouting

public protocol FollowDetailRouting: ViewableRouting {
    // 자식 RIB으로 라우팅하는 메서드 정의
}

// MARK: - FollowDetailRouter

final class FollowDetailRouter: ViewableRouter<FollowDetailInteractable, FollowDetailViewControllable>, FollowDetailRouting {

    override init(
        interactor: FollowDetailInteractable,
        viewController: FollowDetailViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
