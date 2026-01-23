//
//  FollowDetailBuilder.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import RIBs

// MARK: - FollowDetailDependency

public protocol FollowDetailDependency: Dependency {
    // 부모 RIB로부터 주입받을 의존성 정의
}

// MARK: - FollowDetailComponent

final class FollowDetailComponent: Component<FollowDetailDependency> {
    var repository: FollowDetailRepositoryProtocol {
        // TODO: 실제 API 연동 시 실제 Repository로 교체
        MockFollowDetailRepository()
    }
}

// MARK: - FollowDetailBuildable

public protocol FollowDetailBuildable: Buildable {
    func build(withListener listener: FollowDetailListener, recommendationId: Int) -> FollowDetailRouting
}

// MARK: - FollowDetailBuilder

public final class FollowDetailBuilder: Builder<FollowDetailDependency>, FollowDetailBuildable {

    public override init(dependency: FollowDetailDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: FollowDetailListener, recommendationId: Int) -> FollowDetailRouting {
        let component = FollowDetailComponent(dependency: dependency)
        let viewController = FollowDetailViewController()
        let interactor = FollowDetailInteractor(
            presenter: viewController,
            repository: component.repository,
            recommendationId: recommendationId
        )
        interactor.listener = listener

        let router = FollowDetailRouter(
            interactor: interactor,
            viewController: viewController
        )

        return router
    }
}
