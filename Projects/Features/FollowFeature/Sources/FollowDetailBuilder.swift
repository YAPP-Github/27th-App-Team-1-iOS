//
//  FollowDetailBuilder.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import RIBs

// MARK: - FollowDetailDependency

public protocol FollowDetailDependency: Dependency {
    var followService: FollowServiceProtocol { get }
    var travelService: TravelServiceProtocol { get }
}

// MARK: - FollowDetailComponent

final class FollowDetailComponent: Component<FollowDetailDependency>, TripCalendarDependency {
    var followService: FollowServiceProtocol {
        dependency.followService
    }

    var travelService: TravelServiceProtocol {
        dependency.travelService
    }
}

// MARK: - FollowDetailBuildable

public protocol FollowDetailBuildable: Buildable {
    func build(withListener listener: FollowDetailListener, recommendationId: Int) -> FollowDetailRouting
}

// MARK: - FollowDetailBuilder

public final class FollowDetailBuilder: Builder<FollowDetailDependency>, FollowDetailBuildable {

    public override init(dependency: FollowDetailDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: FollowDetailListener, recommendationId: Int) -> FollowDetailRouting {
        let component = FollowDetailComponent(dependency: dependency)
        let viewController = FollowDetailViewController()
        let interactor = FollowDetailInteractor(
            presenter: viewController,
            followService: component.followService,
            travelService: component.travelService,
            recommendationId: recommendationId
        )
        interactor.listener = listener

        let tripCalendarBuilder = TripCalendarBuilder(dependency: component)

        let router = FollowDetailRouter(
            interactor: interactor,
            viewController: viewController,
            tripCalendarBuilder: tripCalendarBuilder
        )

        return router
    }
}
