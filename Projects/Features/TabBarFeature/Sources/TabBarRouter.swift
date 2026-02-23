//
//  TabBarRouter.swift
//  TabBarFeature
//
//  Created by kimnahun on 2026-01-22.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

import HomeFeature
import MyTravelFeature
import TravelToolFeature

// MARK: - TabBarInteractable

protocol TabBarInteractable: Interactable, HomeListener, MyTravelListener, TravelToolListener {
    var router: TabBarRouting? { get set }
    var listener: TabBarListener? { get set }
}

// MARK: - TabBarViewControllable

public protocol TabBarViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [ViewControllable])
    func switchToTab(at index: Int)
}

// MARK: - TabBarRouter

final class TabBarRouter: ViewableRouter<TabBarInteractable, TabBarViewControllable>, TabBarRouting {

    private let homeBuilder: HomeBuildable
    private let myTravelBuilder: MyTravelBuildable
    private let travelToolBuilder: TravelToolBuildable
    private var homeRouter: HomeRouting?
    private var myTravelRouter: MyTravelRouting?
    private var travelToolRouter: TravelToolRouting?

    init(
        interactor: TabBarInteractable,
        viewController: TabBarViewControllable,
        homeBuilder: HomeBuildable,
        myTravelBuilder: MyTravelBuildable,
        travelToolBuilder: TravelToolBuildable
    ) {
        self.homeBuilder = homeBuilder
        self.myTravelBuilder = myTravelBuilder
        self.travelToolBuilder = travelToolBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    override func didLoad() {
        super.didLoad()
        attachTabs()
    }

    // MARK: - TabBarRouting

    func switchToTab(at index: Int) {
        viewController.switchToTab(at: index)
    }

    func attachTabs() {
        guard homeRouter == nil, myTravelRouter == nil, travelToolRouter == nil else { return }

        let travelToolRouter = travelToolBuilder.build(withListener: interactor)
        self.travelToolRouter = travelToolRouter
        attachChild(travelToolRouter)

        let homeRouter = homeBuilder.build(withListener: interactor)
        self.homeRouter = homeRouter
        attachChild(homeRouter)

        let myTravelRouter = myTravelBuilder.build(withListener: interactor)
        self.myTravelRouter = myTravelRouter
        attachChild(myTravelRouter)

        viewController.setViewControllers([
            travelToolRouter.viewControllable,
            homeRouter.viewControllable,
            myTravelRouter.viewControllable
        ])
    }
}
