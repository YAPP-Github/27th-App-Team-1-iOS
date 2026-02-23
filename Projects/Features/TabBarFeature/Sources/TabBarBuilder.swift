//
//  TabBarBuilder.swift
//  TabBarFeature
//
//  Created by kimnahun on 2026-01-22.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import HomeFeature
import MyTravelFeature
import TravelToolFeature

import RIBs

// MARK: - TabBarDependency

public protocol TabBarDependency: Dependency {
    var homeUsecase: HomeUsecaseProtocol { get }
    var weatherRepository: WeatherRepositoryInterface { get }
    var myTravelUsecase: MyTravelUsecaseProtocol { get }
}

// MARK: - TabBarComponent

final class TabBarComponent: Component<TabBarDependency>, HomeDependency, MyTravelDependency, TravelToolDependency {
    var myTravelUsecase: MyTravelUsecaseProtocol {
        dependency.myTravelUsecase
    }
    
    var homeUsecase: HomeUsecaseProtocol {
        dependency.homeUsecase
    }

    var weatherRepository: WeatherRepositoryInterface {
        dependency.weatherRepository
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
        let myTravelBuilder = MyTravelBuilder(dependency: component)
        let travelToolBuilder = TravelToolBuilder(dependency: component)

        let router = TabBarRouter(
            interactor: interactor,
            viewController: viewController,
            homeBuilder: homeBuilder,
            myTravelBuilder: myTravelBuilder,
            travelToolBuilder: travelToolBuilder
        )

        return router
    }
}
