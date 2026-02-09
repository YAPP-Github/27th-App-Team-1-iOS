//
//  PlaceDetailBuilder.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-02-09.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import RIBs

// MARK: - PlaceDetailDependency

protocol PlaceDetailDependency: Dependency {
    var followService: FollowServiceProtocol { get }
}

// MARK: - PlaceDetailComponent

final class PlaceDetailComponent: Component<PlaceDetailDependency> {
    var followService: FollowServiceProtocol {
        dependency.followService
    }
}

// MARK: - PlaceDetailBuildable

protocol PlaceDetailBuildable: Buildable {
    func build(withListener listener: PlaceDetailListener, googlePlaceId: String) -> PlaceDetailRouting
}

// MARK: - PlaceDetailBuilder

final class PlaceDetailBuilder: Builder<PlaceDetailDependency>, PlaceDetailBuildable {

    override init(dependency: PlaceDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PlaceDetailListener, googlePlaceId: String) -> PlaceDetailRouting {
        let component = PlaceDetailComponent(dependency: dependency)
        let viewController = PlaceDetailViewController()
        let interactor = PlaceDetailInteractor(
            presenter: viewController,
            followService: component.followService,
            googlePlaceId: googlePlaceId
        )
        interactor.listener = listener

        let router = PlaceDetailRouter(
            interactor: interactor,
            viewController: viewController
        )

        return router
    }
}
