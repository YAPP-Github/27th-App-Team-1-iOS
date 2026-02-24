//
//  MainInteractor.swift
//  MainFeature
//
//  Created by 최안용 on 2/11/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Core

import RIBs
import RxSwift

public protocol MainRouting: ViewableRouting {
    func attachFollow(with recommendationId: Int)
    func attachMyTravelDetail(with userTravelId: Int)
    func detachFollow()
    func attachPopularTravel()
    func detachPopularTravel()
    func attachSearch()
    func detachSearch()
    func attachSetting()
    func detachSetting()
    func attachTabBar()
    func switchToTab(at index: Int)
}

protocol MainPresentable: Presentable {
    var listener: MainPresentableListener? { get set }
    
    func showServiceNoticeModal()
}

public protocol MainListener: AnyObject { }

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener {
    weak var router: MainRouting?
    weak var listener: MainListener?

    override init(presenter: MainPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachTabBar()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func viewDidLoad() {
        checkFirstOpenStatus()
    }
    
    private func checkFirstOpenStatus() {
        if UserManager.shared.isFirstOpenApp() {
            presenter.showServiceNoticeModal()
        }
    }
    
    func detachFollowDetail() {
        router?.detachFollow()
    }
    
    func followDetailDidViewTrip() {
        router?.detachFollow()
        router?.switchToTab(at: 1)
    }
    
    func popularTravelDidTapFollowDetail(with recommendationId: Int) {
        router?.attachFollow(with: recommendationId)
    }
    
    func popularTravelDidTapSearch() {
        router?.attachSearch()
    }
    
    func routeToPopularTravel() {
        router?.attachPopularTravel()
    }
    
    func detachPopularTravel() {
        router?.detachPopularTravel()
    }
    
    func detachSearch() {
        router?.detachSearch()
    }
    
    func detachSetting() {
        router?.detachSetting()
    }
    
    func routeToFollow(with recommendationId: Int) {
        router?.attachFollow(with: recommendationId)
    }

    func routeToMyTravelDetail(with userTravelId: Int) {
        router?.attachMyTravelDetail(with: userTravelId)
    }
    
    func routeToSetting() {
        router?.attachSetting()
    }
    
    func routeToSearch() {
        router?.attachSearch()
    }
    
    func attachFollowDetail(with recommendationId: Int) {
        router?.attachFollow(with: recommendationId)
    }
}
