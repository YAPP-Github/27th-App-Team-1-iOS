//
//  TravelBuilder.swift
//  TravelFeature
//
//  Created by kimnahun on 2026-01-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

// MARK: - TravelDependency

public protocol TravelDependency: Dependency {
    // 부모 RIB로부터 주입받을 의존성 정의
}

// MARK: - TravelComponent

final class TravelComponent: Component<TravelDependency> {
}

// MARK: - TravelBuildable

public protocol TravelBuildable: Buildable {
    func build(withListener listener: TravelListener) -> TravelRouting
}

// MARK: - TravelBuilder

public final class TravelBuilder: Builder<TravelDependency>, TravelBuildable {

    public override init(dependency: TravelDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: TravelListener) -> TravelRouting {
        let component = TravelComponent(dependency: dependency)
        let viewController = TravelViewController()
        let interactor = TravelInteractor(presenter: viewController)
        interactor.listener = listener

        let router = TravelRouter(
            interactor: interactor,
            viewController: viewController
        )

        return router
    }
}
