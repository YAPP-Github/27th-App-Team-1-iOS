//
//  MainBuilder.swift
//  MainFeature
//
//  Created by 최안용 on 2/11/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Data
import FollowFeature
import PopularTravelFeature
import SettingFeature
import SearchFeature
import TabBarFeature

import RIBs

public protocol MainDependency: Dependency {
    var homeUsecase: HomeUsecaseProtocol { get }
    var tokenProvider: TokenProviding { get }
}

final class MainComponent: Component<MainDependency>, FollowDetailDependency, PopularTravelDependency,SearchDependency, SettingDependency, TabBarDependency {
    var followService: FollowServiceProtocol {
        makeFollowService()
    }
    
    var travelService: TravelServiceProtocol {
        makeTravelService(tokenProvider: tokenProvider)
    }
    
    var tokenProvider: TokenProviding {
        dependency.tokenProvider
    }
    
    var homeUsecase: HomeUsecaseProtocol {
        dependency.homeUsecase
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
