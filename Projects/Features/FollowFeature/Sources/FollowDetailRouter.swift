//
//  FollowDetailRouter.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

// MARK: - FollowDetailInteractable

protocol FollowDetailInteractable: Interactable, TripCalendarListener, PlaceDetailListener {
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
    func routeToTripCalendar(templateTotalDays: Int)
    func detachTripCalendar()
    func routeToPlaceDetail(googlePlaceId: String)
    func detachPlaceDetail()
}

// MARK: - FollowDetailRouter

final class FollowDetailRouter: ViewableRouter<FollowDetailInteractable, FollowDetailViewControllable>, FollowDetailRouting {

    private let tripCalendarBuilder: TripCalendarBuildable
    private var tripCalendarRouter: TripCalendarRouting?

    private let placeDetailBuilder: PlaceDetailBuildable
    private var placeDetailRouter: PlaceDetailRouting?

    init(
        interactor: FollowDetailInteractable,
        viewController: FollowDetailViewControllable,
        tripCalendarBuilder: TripCalendarBuildable,
        placeDetailBuilder: PlaceDetailBuildable
    ) {
        self.tripCalendarBuilder = tripCalendarBuilder
        self.placeDetailBuilder = placeDetailBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    // MARK: - FollowDetailRouting

    func routeToTripCalendar(templateTotalDays: Int) {
        guard tripCalendarRouter == nil else { return }

        let router = tripCalendarBuilder.build(withListener: interactor, templateTotalDays: templateTotalDays)
        tripCalendarRouter = router
        attachChild(router)
        viewController.present(router.viewControllable)
    }

    func detachTripCalendar() {
        guard let router = tripCalendarRouter else { return }

        // TripCalendar VC가 아직 네비게이션 스택에 있는 경우에만 pop
        if let navController = viewController.uiviewController.navigationController,
           navController.viewControllers.contains(router.viewControllable.uiviewController) {
            viewController.dismiss(router.viewControllable)
        }

        detachChild(router)
        tripCalendarRouter = nil
    }

    func routeToPlaceDetail(googlePlaceId: String) {
        guard placeDetailRouter == nil else { return }

        let router = placeDetailBuilder.build(withListener: interactor, googlePlaceId: googlePlaceId)
        placeDetailRouter = router
        attachChild(router)
        viewController.present(router.viewControllable)
    }

    func detachPlaceDetail() {
        guard let router = placeDetailRouter else { return }

        if let navController = viewController.uiviewController.navigationController,
           navController.viewControllers.contains(router.viewControllable.uiviewController) {
            viewController.dismiss(router.viewControllable)
        }

        detachChild(router)
        placeDetailRouter = nil
    }
}
