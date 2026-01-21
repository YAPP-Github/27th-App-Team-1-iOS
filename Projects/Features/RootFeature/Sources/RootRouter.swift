//
//  RootRouter.swift
//  RootFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

import HomeFeature

// MARK: - RootInteractable

protocol RootInteractable: Interactable, HomeListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

// MARK: - RootViewControllable

public protocol RootViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
    func setRootViewController(_ viewController: ViewControllable)
}

// MARK: - RootRouting

public protocol RootRouting: ViewableRouting {
    func attachHome()
    func detachHome()
}

// MARK: - RootRouter

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    private let homeBuilder: HomeBuildable
    private var homeRouter: HomeRouting?

    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        homeBuilder: HomeBuildable
    ) {
        self.homeBuilder = homeBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    override func didLoad() {
        super.didLoad()
        attachHome()
    }

    // MARK: - RootRouting

    func attachHome() {
        guard homeRouter == nil else { return }

        let router = homeBuilder.build(withListener: interactor)
        homeRouter = router
        attachChild(router)
        viewController.setRootViewController(router.viewControllable)
    }

    func detachHome() {
        guard let router = homeRouter else { return }

        detachChild(router)
        homeRouter = nil
    }
}
