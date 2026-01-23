//
//  HomeBuilder.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import FollowFeature
import RIBs

// MARK: - HomeDependency

public protocol HomeDependency: Dependency {
    // 부모 RIB로부터 주입받을 의존성 정의
}

// MARK: - HomeComponent

final class HomeComponent: Component<HomeDependency>, FollowDetailDependency {
    var travelRepository: TravelRepositoryProtocol {
        // TODO: 실제 API 연동 시 실제 Repository로 교체
        MockTravelRepository()
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
            repository: component.travelRepository
        )
        interactor.listener = listener

        let followDetailBuilder = FollowDetailBuilder(dependency: component)

        let router = HomeRouter(
            interactor: interactor,
            viewController: viewController,
            followDetailBuilder: followDetailBuilder
        )

        return router
    }
}
