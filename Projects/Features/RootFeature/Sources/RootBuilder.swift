//
//  RootBuilder.swift
//  RootFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import RIBs
import TabBarFeature

// MARK: - RootDependency

public protocol RootDependency: Dependency {
    var tokenProvider: TokenProviding { get }
}

// MARK: - RootComponent

final class RootComponent: Component<RootDependency>, TabBarDependency {
    var tokenProvider: TokenProviding {
        dependency.tokenProvider
    }
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

        let tabBarBuilder = TabBarBuilder(dependency: component)

        let router = RootRouter(
            interactor: interactor,
            viewController: viewController,
            tabBarBuilder: tabBarBuilder
        )

        return router
    }
}
