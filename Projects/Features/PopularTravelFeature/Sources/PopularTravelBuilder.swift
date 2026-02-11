//
//  PopularTravelBuilder.swift
//  PopularTravelFeature
//
//  Created by 최안용 on 2/12/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain

import RIBs

public protocol PopularTravelDependency: Dependency {
    var homeUsecase: HomeUsecaseProtocol { get }
}

final class PopularTravelComponent: Component<PopularTravelDependency> {
    var homeUsecase: HomeUsecaseProtocol {
        return dependency.homeUsecase
    }
}

// MARK: - Builder

public protocol PopularTravelBuildable: Buildable {
    func build(withListener listener: PopularTravelListener) -> PopularTravelRouting
}

public final class PopularTravelBuilder: Builder<PopularTravelDependency>, PopularTravelBuildable {

    override public init(dependency: PopularTravelDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: PopularTravelListener) -> PopularTravelRouting {
        let component = PopularTravelComponent(dependency: dependency)
        let viewController = PopularTravelViewController()
        let interactor = PopularTravelInteractor(
            presenter: viewController,
            usecase: component.homeUsecase
        )
        interactor.listener = listener
        return PopularTravelRouter(interactor: interactor, viewController: viewController)
    }
}
