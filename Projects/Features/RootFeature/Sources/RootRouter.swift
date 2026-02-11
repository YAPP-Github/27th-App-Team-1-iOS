//
//  RootRouter.swift
//  RootFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

import MainFeature

// MARK: - RootInteractable

protocol RootInteractable: Interactable, MainListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

// MARK: - RootViewControllable

public protocol RootViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
    func setRootViewController(_ viewController: ViewControllable)
}

// MARK: - RootRouter

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    private let mainBuilder: MainBuildable
    private var mainRouter: MainRouting?

    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        mainBuilder: MainBuildable
    ) {
        self.mainBuilder = mainBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    override func didLoad() {
        super.didLoad()
        attachMain()
    }

    // MARK: - RootRouting

    func attachMain() {
        guard mainRouter == nil else { return }

        let router = mainBuilder.build(withListener: interactor)
        mainRouter = router
        attachChild(router)
        viewController.setRootViewController(router.viewControllable)
    }

    func detachMain() {
        guard let router = mainRouter else { return }

        detachChild(router)
        mainRouter = nil
    }
}
