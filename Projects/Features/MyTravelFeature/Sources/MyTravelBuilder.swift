//
//  MyTravelBuilder.swift
//  MyTravelFeature
//
//  Created by 최안용 on 2/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

protocol MyTravelDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MyTravelComponent: Component<MyTravelDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MyTravelBuildable: Buildable {
    func build(withListener listener: MyTravelListener) -> MyTravelRouting
}

final class MyTravelBuilder: Builder<MyTravelDependency>, MyTravelBuildable {

    override init(dependency: MyTravelDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MyTravelListener) -> MyTravelRouting {
        let component = MyTravelComponent(dependency: dependency)
        let viewController = MyTravelViewController()
        let interactor = MyTravelInteractor(presenter: viewController)
        interactor.listener = listener
        return MyTravelRouter(interactor: interactor, viewController: viewController)
    }
}
