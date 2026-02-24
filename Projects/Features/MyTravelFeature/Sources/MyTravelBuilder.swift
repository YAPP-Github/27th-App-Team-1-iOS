//
//  MyTravelBuilder.swift
//  MyTravelFeature
//
//  Created by 최안용 on 2/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain

import RIBs

public protocol MyTravelDependency: Dependency {
    var myTravelUsecase: MyTravelUsecaseProtocol { get }
}

final class MyTravelComponent: Component<MyTravelDependency> {
    var myTravelUsecase: MyTravelUsecaseProtocol {
        dependency.myTravelUsecase
    }
}

// MARK: - Builder

public protocol MyTravelBuildable: Buildable {
    func build(withListener listener: MyTravelListener) -> MyTravelRouting
}

public final class MyTravelBuilder: Builder<MyTravelDependency>, MyTravelBuildable {

    override public init(dependency: MyTravelDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: MyTravelListener) -> MyTravelRouting {
        let component = MyTravelComponent(dependency: dependency)
        let viewController = MyTravelViewController()
        let interactor = MyTravelInteractor(presenter: viewController, usecase: component.myTravelUsecase)
        interactor.listener = listener
        
        return MyTravelRouter(interactor: interactor, viewController: viewController)
    }
}
