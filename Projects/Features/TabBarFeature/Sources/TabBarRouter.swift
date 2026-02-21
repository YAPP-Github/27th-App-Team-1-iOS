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
import TravelToolFeature

// MARK: - TabBarInteractable

protocol TabBarInteractable: Interactable, HomeListener, TravelListener, TravelToolListener {
    var router: TabBarRouting? { get set }
    var listener: TabBarListener? { get set }
}

// MARK: - TabBarViewControllable

public protocol TabBarViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [ViewControllable])
}

// MARK: - TabBarRouter

final class TabBarRouter: ViewableRouter<TabBarInteractable, TabBarViewControllable>, TabBarRouting {

    private let homeBuilder: HomeBuildable
    private let travelBuilder: TravelBuildable
    private let travelToolBuilder: TravelToolBuildable
    private var homeRouter: HomeRouting?
    private var travelRouter: TravelRouting?
    private var travelToolRouter: TravelToolRouting?

    init(
        interactor: TabBarInteractable,
        viewController: TabBarViewControllable,
        homeBuilder: HomeBuildable,
        travelBuilder: TravelBuildable,
        travelToolBuilder: TravelToolBuildable
    ) {
        self.homeBuilder = homeBuilder
        self.travelBuilder = travelBuilder
        self.travelToolBuilder = travelToolBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    override func didLoad() {
        super.didLoad()
        attachTabs()
    }

    // MARK: - TabBarRouting

    func attachTabs() {
        guard homeRouter == nil, travelRouter == nil, travelToolRouter == nil else { return }

        let travelToolRouter = travelToolBuilder.build(withListener: interactor)
        self.travelToolRouter = travelToolRouter
        attachChild(travelToolRouter)

        let homeRouter = homeBuilder.build(withListener: interactor)
        self.homeRouter = homeRouter
        attachChild(homeRouter)

        let travelRouter = travelBuilder.build(withListener: interactor)
        self.travelRouter = travelRouter
        attachChild(travelRouter)

        viewController.setViewControllers([
            travelToolRouter.viewControllable,
            homeRouter.viewControllable,
            travelRouter.viewControllable
        ])
    }
}
