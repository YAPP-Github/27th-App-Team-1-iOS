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
    var followRepository: FollowRepositoryProtocol { get }
}

// MARK: - FollowDetailComponent

final class FollowDetailComponent: Component<FollowDetailDependency> {
    var repository: FollowRepositoryProtocol {
        dependency.followRepository
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
