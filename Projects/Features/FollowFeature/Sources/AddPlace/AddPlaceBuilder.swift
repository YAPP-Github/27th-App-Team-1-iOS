//
//  AddPlaceBuilder.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-02-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain

import RIBs

// MARK: - AddPlaceDependency

protocol AddPlaceDependency: Dependency {
    var followDetailUsecase: FollowDetailUsecaseProtocol { get }
}

// MARK: - AddPlaceComponent

final class AddPlaceComponent: Component<AddPlaceDependency> {
    var followDetailUsecase: FollowDetailUsecaseProtocol {
        dependency.followDetailUsecase
    }
}

// MARK: - AddPlaceBuildable

protocol AddPlaceBuildable: Buildable {
    func build(withListener listener: AddPlaceListener) -> AddPlaceRouting
}

// MARK: - AddPlaceBuilder

final class AddPlaceBuilder: Builder<AddPlaceDependency>, AddPlaceBuildable {

    override init(dependency: AddPlaceDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddPlaceListener) -> AddPlaceRouting {
        let component = AddPlaceComponent(dependency: dependency)
        let viewController = AddPlaceViewController()
        let interactor = AddPlaceInteractor(
            presenter: viewController,
            followDetailUsecase: component.followDetailUsecase
        )
        interactor.listener = listener

        let router = AddPlaceRouter(interactor: interactor, viewController: viewController)
        return router
    }
}
