//
//  TripCalendarRouter.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

// MARK: - TripCalendarInteractable

protocol TripCalendarInteractable: Interactable {
    var router: TripCalendarRouting? { get set }
    var listener: TripCalendarListener? { get set }
}

// MARK: - TripCalendarViewControllable

protocol TripCalendarViewControllable: ViewControllable {
}

// MARK: - TripCalendarRouting

protocol TripCalendarRouting: ViewableRouting {
}

// MARK: - TripCalendarRouter

final class TripCalendarRouter: ViewableRouter<TripCalendarInteractable, TripCalendarViewControllable>, TripCalendarRouting {

    override init(
        interactor: TripCalendarInteractable,
        viewController: TripCalendarViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
