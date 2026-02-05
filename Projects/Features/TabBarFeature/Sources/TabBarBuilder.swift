//
//  TabBarBuilder.swift
//  TabBarFeature
//
//  Created by kimnahun on 2026-01-22.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import HomeFeature
import RIBs
import TravelFeature

// MARK: - TabBarDependency

public protocol TabBarDependency: Dependency {
    var tokenProvider: TokenProviding { get }
}

// MARK: - TabBarComponent

final class TabBarComponent: Component<TabBarDependency>, HomeDependency, TravelDependency {
    var tokenProvider: TokenProviding {
        dependency.tokenProvider
    }
}

// MARK: - TabBarBuildable

public protocol TabBarBuildable: Buildable {
    func build(withListener listener: TabBarListener) -> TabBarRouting
}

// MARK: - TabBarBuilder

public final class TabBarBuilder: Builder<TabBarDependency>, TabBarBuildable {

    public override init(dependency: TabBarDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: TabBarListener) -> TabBarRouting {
        let component = TabBarComponent(dependency: dependency)
        let viewController = TabBarViewController()
        let interactor = TabBarInteractor(presenter: viewController)
        interactor.listener = listener

        let homeBuilder = HomeBuilder(dependency: component)
        let travelBuilder = TravelBuilder(dependency: component)

        let router = TabBarRouter(
            interactor: interactor,
            viewController: viewController,
            homeBuilder: homeBuilder,
            travelBuilder: travelBuilder
        )

        return router
    }
}
