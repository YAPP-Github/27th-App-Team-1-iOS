//
//  HomeBuilder.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain

import RIBs

// MARK: - HomeDependency

public protocol HomeDependency: Dependency {
    var homeUsecase: HomeUsecaseProtocol { get }
}

// MARK: - HomeComponent

final class HomeComponent: Component<HomeDependency> {
    var homeUsecase: HomeUsecaseProtocol {
        dependency.homeUsecase
    }
}

// MARK: - HomeBuildable

public protocol HomeBuildable: Buildable {
    func build(withListener listener: HomeListener) -> HomeRouting
}

// MARK: - HomeBuilder

public final class HomeBuilder: Builder<HomeDependency>, HomeBuildable {

    override public init(dependency: HomeDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: HomeListener) -> HomeRouting {
        let component = HomeComponent(dependency: dependency)
        let viewController = HomeViewController()
        let interactor = HomeInteractor(
            presenter: viewController,
            usecase: component.homeUsecase
        )
        interactor.listener = listener
        
        return HomeRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}
