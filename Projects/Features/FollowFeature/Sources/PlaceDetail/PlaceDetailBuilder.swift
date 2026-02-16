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
    var followDetailUsecase: FollowDetailUsecaseProtocol { get }
}

// MARK: - PlaceDetailComponent

final class PlaceDetailComponent: Component<PlaceDetailDependency> {
    var followDetailUsecase: FollowDetailUsecaseProtocol {
        dependency.followDetailUsecase
    }
}

// MARK: - PlaceDetailBuildable

protocol PlaceDetailBuildable: Buildable {
    func build(withListener listener: PlaceDetailListener, travelPlace: TravelPlace, youtuberName: String) -> PlaceDetailRouting
}

// MARK: - PlaceDetailBuilder

final class PlaceDetailBuilder: Builder<PlaceDetailDependency>, PlaceDetailBuildable {

    override init(dependency: PlaceDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PlaceDetailListener, travelPlace: TravelPlace, youtuberName: String) -> PlaceDetailRouting {
        let component = PlaceDetailComponent(dependency: dependency)
        let viewController = PlaceDetailViewController()
        let interactor = PlaceDetailInteractor(
            presenter: viewController,
            followDetailUsecase: component.followDetailUsecase,
            travelPlace: travelPlace,
            youtuberName: youtuberName
        )
        interactor.listener = listener

        let router = PlaceDetailRouter(
            interactor: interactor,
            viewController: viewController
        )

        return router
    }
}
