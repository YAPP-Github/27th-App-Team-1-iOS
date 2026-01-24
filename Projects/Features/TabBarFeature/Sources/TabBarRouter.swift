//
//  TabBarRouter.swift
//  TabBarFeature
//
//  Created by kimnahun on 2026-01-22.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

import HomeFeature
import TravelFeature

// MARK: - TabBarInteractable

protocol TabBarInteractable: Interactable, HomeListener, TravelListener {
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
    private let travelBuilder: TravelBuildable
    private var homeRouter: HomeRouting?
    private var travelRouter: TravelRouting?

    init(
        interactor: TabBarInteractable,
        viewController: TabBarViewControllable,
        homeBuilder: HomeBuildable,
        travelBuilder: TravelBuildable
    ) {
        self.homeBuilder = homeBuilder
        self.travelBuilder = travelBuilder
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

        let travelRouter = travelBuilder.build(withListener: interactor)
        self.travelRouter = travelRouter
        attachChild(travelRouter)

        // Home과 Travel VC 전달
        viewController.setViewControllers([
            homeRouter.viewControllable,
            travelRouter.viewControllable
        ])
    }
}
