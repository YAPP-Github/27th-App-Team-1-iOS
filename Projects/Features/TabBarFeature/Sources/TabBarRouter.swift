//
//  TabBarRouter.swift
//  TabBarFeature
//
//  Created by kimnahun on 2026-01-22.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

import HomeFeature

// MARK: - TabBarInteractable

protocol TabBarInteractable: Interactable, HomeListener {
    var router: TabBarRouting? { get set }
    var listener: TabBarListener? { get set }
}

// MARK: - TabBarViewControllable

public protocol TabBarViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [ViewControllable])
}

// MARK: - TabBarRouting

public protocol TabBarRouting: ViewableRouting {
    func attachTabs()
}

// MARK: - TabBarRouter

final class TabBarRouter: ViewableRouter<TabBarInteractable, TabBarViewControllable>, TabBarRouting {

    private let homeBuilder: HomeBuildable
    private var homeRouter: HomeRouting?

    init(
        interactor: TabBarInteractable,
        viewController: TabBarViewControllable,
        homeBuilder: HomeBuildable
    ) {
        self.homeBuilder = homeBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    override func didLoad() {
        super.didLoad()
        attachTabs()
    }

    // MARK: - TabBarRouting

    func attachTabs() {
        let homeRouter = homeBuilder.build(withListener: interactor)
        self.homeRouter = homeRouter
        attachChild(homeRouter)

        // 탭에 표시할 ViewController 설정
        viewController.setViewControllers([homeRouter.viewControllable])
    }
}
