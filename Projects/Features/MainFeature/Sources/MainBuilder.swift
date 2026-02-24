//
//  MainBuilder.swift
//  MainFeature
//
//  Created by 최안용 on 2/11/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import FollowFeature
import PopularTravelFeature
import SearchFeature
import SettingFeature
import TabBarFeature

import RIBs

public protocol MainDependency: Dependency {
    var homeUsecase: HomeUsecaseProtocol { get }
    var followDetailUsecase: FollowDetailUsecaseProtocol { get }
    var templateSearchUsecase: TemplatesSearchUsecaseProtocol { get }
    var weatherRepository: WeatherRepositoryInterface { get }
    var myTravelUsecase: MyTravelUsecaseProtocol { get }
}

final class MainComponent: Component<MainDependency>, FollowDetailDependency, PopularTravelDependency,SearchDependency, SettingDependency, TabBarDependency {
    var myTravelUsecase: MyTravelUsecaseProtocol {
        dependency.myTravelUsecase
    }
    
    var searchUsecase: TemplatesSearchUsecaseProtocol {
        dependency.templateSearchUsecase
    }

    var followDetailUsecase: FollowDetailUsecaseProtocol {
        dependency.followDetailUsecase
    }

    var homeUsecase: HomeUsecaseProtocol {
        dependency.homeUsecase
    }

    var weatherRepository: WeatherRepositoryInterface {
        dependency.weatherRepository
    }
}

// MARK: - Builder

public protocol MainBuildable: Buildable {
    func build(withListener listener: MainListener) -> MainRouting
}

public final class MainBuilder: Builder<MainDependency>, MainBuildable {

    override public init(dependency: MainDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: MainListener) -> MainRouting {
        let component = MainComponent(dependency: dependency)
        let viewController = MainViewController()
        let interactor = MainInteractor(presenter: viewController)
        interactor.listener = listener
        
        let followBuilder = FollowDetailBuilder(dependency: component)
        let popularTravelBuilder = PopularTravelBuilder(dependency: component)
        let searchBuilder = SearchBuilder(dependency: component)
        let settingBuilder = SettingBuilder(dependency: component)
        let tabBarBuilder = TabBarBuilder(dependency: component)
                
        return MainRouter(
            interactor: interactor,
            viewController: viewController,
            followBuilder: followBuilder,
            popularTravelBuilder: popularTravelBuilder,
            searchBuilder: searchBuilder,
            settingBuilder: settingBuilder,
            tabBarBuilder: tabBarBuilder
        )
    }
}
