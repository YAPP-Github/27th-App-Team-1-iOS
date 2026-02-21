//
//  TravelToolBuilder.swift
//  TravelToolFeature
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import RIBs

// MARK: - TravelToolDependency

public protocol TravelToolDependency: Dependency {
    var homeUsecase: HomeUsecaseProtocol { get }
}

// MARK: - TravelToolComponent

final class TravelToolComponent: Component<TravelToolDependency> {
    var homeUsecase: HomeUsecaseProtocol {
        dependency.homeUsecase
    }
}

// MARK: - TravelToolBuildable

public protocol TravelToolBuildable: Buildable {
    func build(withListener listener: TravelToolListener) -> TravelToolRouting
}

// MARK: - TravelToolBuilder

public final class TravelToolBuilder: Builder<TravelToolDependency>, TravelToolBuildable {

    public override init(dependency: TravelToolDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: TravelToolListener) -> TravelToolRouting {
        let component = TravelToolComponent(dependency: dependency)
        let viewController = TravelToolViewController()
        let interactor = TravelToolInteractor(
            presenter: viewController,
            usecase: component.homeUsecase
        )
        interactor.listener = listener

        let router = TravelToolRouter(
            interactor: interactor,
            viewController: viewController
        )

        return router
    }
}
