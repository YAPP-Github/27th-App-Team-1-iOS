//
//  FollowDetailRouter.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

// MARK: - FollowDetailInteractable

protocol FollowDetailInteractable: Interactable, TripCalendarListener {
    var router: FollowDetailRouting? { get set }
    var listener: FollowDetailListener? { get set }
}

// MARK: - FollowDetailViewControllable

public protocol FollowDetailViewControllable: ViewControllable {
    func present(_ viewController: ViewControllable)
    func dismiss(_ viewController: ViewControllable)
}

// MARK: - FollowDetailRouting

public protocol FollowDetailRouting: ViewableRouting {
    func routeToTripCalendar()
    func detachTripCalendar()
}

// MARK: - FollowDetailRouter

final class FollowDetailRouter: ViewableRouter<FollowDetailInteractable, FollowDetailViewControllable>, FollowDetailRouting {

    private let tripCalendarBuilder: TripCalendarBuildable
    private var tripCalendarRouter: TripCalendarRouting?

    init(
        interactor: FollowDetailInteractable,
        viewController: FollowDetailViewControllable,
        tripCalendarBuilder: TripCalendarBuildable
    ) {
        self.tripCalendarBuilder = tripCalendarBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    // MARK: - FollowDetailRouting

    func routeToTripCalendar() {
        guard tripCalendarRouter == nil else { return }

        let router = tripCalendarBuilder.build(withListener: interactor)
        tripCalendarRouter = router
        attachChild(router)
        viewController.present(router.viewControllable)
    }

    func detachTripCalendar() {
        guard let router = tripCalendarRouter else { return }

        viewController.dismiss(router.viewControllable)
        detachChild(router)
        tripCalendarRouter = nil
    }
}
