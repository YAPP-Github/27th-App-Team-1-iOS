//
//  HomeRouter.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

// MARK: - HomeInteractable

protocol HomeInteractable: Interactable {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

// MARK: - HomeViewControllable

public protocol HomeViewControllable: ViewControllable {
    // ViewController에 요청할 화면 전환 메서드 정의
}

// MARK: - HomeRouting

public protocol HomeRouting: ViewableRouting {
    // 자식 RIB으로 라우팅하는 메서드 정의
}

// MARK: - HomeRouter

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {

    override init(
        interactor: HomeInteractable,
        viewController: HomeViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
