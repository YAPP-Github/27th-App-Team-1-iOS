//
//  MainRouter.swift
//  MainFeature
//
//  Created by 최안용 on 2/11/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import FollowFeature
import PopularTravelFeature
import SearchFeature
import SettingFeature
import TabBarFeature

import RIBs

protocol MainInteractable: Interactable, FollowDetailListener, PopularTravelListener, SearchListener, SettingListener, TabBarListener {
    var router: MainRouting? { get set }
    var listener: MainListener? { get set }
}

public protocol MainViewControllable: ViewControllable {
    func setViewControllers(_ viewControllables: [ViewControllable])
    func pushViewController(_ viewControllable: ViewControllable, animated: Bool)
    func popRootViewController(animated: Bool)
    func containsInStack(_ viewControllable: ViewControllable) -> Bool
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable>, MainRouting {
    private let followBuilder: FollowDetailBuildable
    private var followRouter: FollowDetailRouting?

    private let popularTravelBuilder: PopularTravelBuildable
    private var popularTravelRouter: PopularTravelRouting?
    
    private let searchBuilder: SearchBuildable
    private var searchRouter: SearchRouting?
    
    private let settingBuilder: SettingBuildable
    private var settingRouter: SettingRouting?
    
    private let tabBarBuilder: TabBarBuildable
    private var tabBarRouter: TabBarRouting?
    
    init(
        interactor: MainInteractable,
        viewController: MainViewControllable,
        followBuilder: FollowDetailBuildable,
        popularTravelBuilder: PopularTravelBuildable,
        searchBuilder: SearchBuildable,
        settingBuilder: SettingBuildable,
        tabBarBuilder: TabBarBuildable
    ) {
        self.followBuilder = followBuilder
        self.popularTravelBuilder = popularTravelBuilder
        self.searchBuilder = searchBuilder
        self.settingBuilder = settingBuilder
        self.tabBarBuilder = tabBarBuilder
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachFollow(with recommendationId: Int) {
        guard followRouter == nil else { return }
        let router = followBuilder.build(
            withListener: interactor,
            recommendationId: recommendationId
        )
        self.followRouter = router
        attachChild(router)
        viewController.pushViewController(router.viewControllable, animated: true)
    }
    
    func detachFollow() {
        guard let router = followRouter else { return }
        
        if viewController.containsInStack(router.viewControllable) {
            viewController.popRootViewController(animated: true)
        }
        
        detachChild(router)
        self.followRouter = nil
    }
    
    func attachPopularTravel() {
        guard popularTravelRouter == nil else { return }
        let router = popularTravelBuilder.build(withListener: interactor)
        self.popularTravelRouter = router
        attachChild(router)
        viewController.pushViewController(router.viewControllable, animated: true)
    }
    
    func detachPopularTravel() {
        guard let router = popularTravelRouter else { return }
        
        if viewController.containsInStack(router.viewControllable) {
            viewController.popRootViewController(animated: true)
        }
        
        detachChild(router)
        self.popularTravelRouter = nil
    }
    
    func attachSearch() {
        guard searchRouter == nil else { return }
        let router = searchBuilder.build(withListener: interactor)
        self.searchRouter = router
        attachChild(router)
        viewController.pushViewController(router.viewControllable, animated: false)
    }
    
    func detachSearch() {
        guard let router = searchRouter else { return }
        
        if viewController.containsInStack(router.viewControllable) {
            viewController.popRootViewController(animated: false)
        }
        
        detachChild(router)
        self.searchRouter = nil
    }
    
    func attachSetting() {
        guard settingRouter == nil else { return }
        let router = settingBuilder.build(withListener: interactor)
        self.settingRouter = router
        attachChild(router)
        viewController.pushViewController(router.viewControllable, animated: true)
    }
    
    func detachSetting() {
        guard let router = settingRouter else { return }
        
        if viewController.containsInStack(router.viewControllable) {
            viewController.popRootViewController(animated: true)
        }
        
        detachChild(router)
        self.settingRouter = nil
    }
    
    func switchToTab(at index: Int) {
        tabBarRouter?.switchToTab(at: index)
    }

    func attachTabBar() {
        guard tabBarRouter == nil else { return }
        let router = tabBarBuilder.build(withListener: interactor)
        self.tabBarRouter = router
        attachChild(router)
        
        viewController.setViewControllers([router.viewControllable])
    }
}
