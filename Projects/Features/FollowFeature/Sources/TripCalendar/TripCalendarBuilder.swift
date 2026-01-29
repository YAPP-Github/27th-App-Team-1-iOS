//
//  TripCalendarBuilder.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

// MARK: - TripCalendarDependency

protocol TripCalendarDependency: Dependency {
}

// MARK: - TripCalendarComponent

final class TripCalendarComponent: Component<TripCalendarDependency> {
}

// MARK: - TripCalendarBuildable

protocol TripCalendarBuildable: Buildable {
    func build(withListener listener: TripCalendarListener) -> TripCalendarRouting
}

// MARK: - TripCalendarBuilder

final class TripCalendarBuilder: Builder<TripCalendarDependency>, TripCalendarBuildable {

    override init(dependency: TripCalendarDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TripCalendarListener) -> TripCalendarRouting {
        let viewController = TripCalendarViewController()
        let interactor = TripCalendarInteractor(presenter: viewController)
        interactor.listener = listener

        let router = TripCalendarRouter(
            interactor: interactor,
            viewController: viewController
        )

        return router
    }
}
