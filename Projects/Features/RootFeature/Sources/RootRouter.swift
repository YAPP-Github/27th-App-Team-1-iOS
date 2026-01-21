//
//  RootRouter.swift
//  RootFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

import TabBarFeature

// MARK: - RootInteractable

protocol RootInteractable: Interactable, TabBarListener {
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
    func attachTabBar()
    func detachTabBar()
}

// MARK: - RootRouter

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    private let tabBarBuilder: TabBarBuildable
    private var tabBarRouter: TabBarRouting?

    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        tabBarBuilder: TabBarBuildable
    ) {
        self.tabBarBuilder = tabBarBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    override func didLoad() {
        super.didLoad()
        attachTabBar()
    }

    // MARK: - RootRouting

    func attachTabBar() {
        guard tabBarRouter == nil else { return }

        let router = tabBarBuilder.build(withListener: interactor)
        tabBarRouter = router
        attachChild(router)
        viewController.setRootViewController(router.viewControllable)
    }

    func detachTabBar() {
        guard let router = tabBarRouter else { return }

        detachChild(router)
        tabBarRouter = nil
    }
}
