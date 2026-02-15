//
//  RootBuilder.swift
//  RootFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import MainFeature

import RIBs

// MARK: - RootDependency

public protocol RootDependency: Dependency {
    var homeUsecase: HomeUsecaseProtocol { get }
}

// MARK: - RootComponent

final class RootComponent: Component<RootDependency>, MainDependency {
    var homeUsecase: HomeUsecaseProtocol {
        dependency.homeUsecase
    }
}

// MARK: - RootBuildable

public protocol RootBuildable: Buildable {
    func build() -> LaunchRouting
}

// MARK: - RootBuilder

public final class RootBuilder: Builder<RootDependency>, RootBuildable {

    override public init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    public func build() -> LaunchRouting {
        let component = RootComponent(dependency: dependency)
        let viewController = RootViewController()
        let interactor = RootInteractor(presenter: viewController)

        let mainBuilder = MainBuilder(dependency: component)

        let router = RootRouter(
            interactor: interactor,
            viewController: viewController,
            mainBuilder: mainBuilder
        )

        return router
    }
}
