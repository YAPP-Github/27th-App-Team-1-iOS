//
//  RootBuilder.swift
//  RootFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

import HomeFeature

// MARK: - RootDependency

public protocol RootDependency: Dependency {
    // Root는 최상위 RIB이므로 외부 의존성이 없음
}

// MARK: - RootComponent

final class RootComponent: Component<RootDependency>, HomeDependency {
    // Home RIB에 전달할 의존성
}

// MARK: - RootBuildable

public protocol RootBuildable: Buildable {
    func build() -> LaunchRouting
}

// MARK: - RootBuilder

public final class RootBuilder: Builder<RootDependency>, RootBuildable {

    public override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    public func build() -> LaunchRouting {
        let component = RootComponent(dependency: dependency)
        let viewController = RootViewController()
        let interactor = RootInteractor(presenter: viewController)

        let homeBuilder = HomeBuilder(dependency: component)

        let router = RootRouter(
            interactor: interactor,
            viewController: viewController,
            homeBuilder: homeBuilder
        )

        return router
    }
}
