//
//  HomeRouter.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

import FollowFeature

// MARK: - HomeInteractable

protocol HomeInteractable: Interactable, FollowDetailListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

// MARK: - HomeViewControllable

public protocol HomeViewControllable: ViewControllable {
    func push(_ viewController: ViewControllable)
    func pop()
}

// MARK: - HomeRouting

public protocol HomeRouting: ViewableRouting {
    func routeToFollowDetail(with recommendationId: Int)
    func detachFollowDetail()
}

// MARK: - HomeRouter

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {

    private let followDetailBuilder: FollowDetailBuildable
    private var followDetailRouter: FollowDetailRouting?

    init(
        interactor: HomeInteractable,
        viewController: HomeViewControllable,
        followDetailBuilder: FollowDetailBuildable
    ) {
        self.followDetailBuilder = followDetailBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    // MARK: - HomeRouting

    func routeToFollowDetail(with recommendationId: Int) {
        guard followDetailRouter == nil else { return }

        let router = followDetailBuilder.build(withListener: interactor, recommendationId: recommendationId)
        followDetailRouter = router
        attachChild(router)
        viewController.push(router.viewControllable)
    }

    func detachFollowDetail() {
        guard let router = followDetailRouter else { return }

        viewController.pop()
        detachChild(router)
        followDetailRouter = nil
    }
}
