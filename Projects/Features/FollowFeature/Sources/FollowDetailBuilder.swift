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
    var followDetailUsecase: FollowDetailUsecaseProtocol { get }
}

// MARK: - FollowDetailComponent

final class FollowDetailComponent: Component<FollowDetailDependency>, TripCalendarDependency, PlaceDetailDependency {
    var followDetailUsecase: FollowDetailUsecaseProtocol {
        dependency.followDetailUsecase
    }
}

// MARK: - FollowDetailMode

public enum FollowDetailMode {
    case template(id: Int)
    case myTravel(id: Int)
}

// MARK: - FollowDetailBuildable

public protocol FollowDetailBuildable: Buildable {
    func build(withListener listener: FollowDetailListener, mode: FollowDetailMode) -> FollowDetailRouting
}

// MARK: - FollowDetailBuilder

public final class FollowDetailBuilder: Builder<FollowDetailDependency>, FollowDetailBuildable {

    override public init(dependency: FollowDetailDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: FollowDetailListener, mode: FollowDetailMode) -> FollowDetailRouting {
        let component = FollowDetailComponent(dependency: dependency)
        let viewController = FollowDetailViewController()
        let interactor = FollowDetailInteractor(
            presenter: viewController,
            followDetailUsecase: component.followDetailUsecase,
            mode: mode
        )
        interactor.listener = listener

        let tripCalendarBuilder = TripCalendarBuilder(dependency: component)
        let placeDetailBuilder = PlaceDetailBuilder(dependency: component)

        let router = FollowDetailRouter(
            interactor: interactor,
            viewController: viewController,
            tripCalendarBuilder: tripCalendarBuilder,
            placeDetailBuilder: placeDetailBuilder
        )

        return router
    }
}
