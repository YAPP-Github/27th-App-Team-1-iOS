//
//  FollowDetailBuilder.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

// MARK: - FollowDetailDependency

public protocol FollowDetailDependency: Dependency {
    // 부모 RIB로부터 주입받을 의존성 정의
}

// MARK: - FollowDetailComponent

final class FollowDetailComponent: Component<FollowDetailDependency> {
    // 자식 RIB에 전달할 의존성
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
        _ = FollowDetailComponent(dependency: dependency)
        let viewController = FollowDetailViewController()
        let interactor = FollowDetailInteractor(
            presenter: viewController,
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
