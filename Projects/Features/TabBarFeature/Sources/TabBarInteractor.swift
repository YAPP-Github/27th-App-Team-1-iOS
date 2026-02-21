//
//  TabBarInteractor.swift
//  TabBarFeature
//
//  Created by kimnahun on 2026-01-22.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import HomeFeature
import RIBs
import RxSwift
import TravelToolFeature

// MARK: - TabBarRouting

public protocol TabBarRouting: ViewableRouting {
    func attachTabs()
}

// MARK: - TabBarPresentable

protocol TabBarPresentable: Presentable {
    var listener: TabBarPresentableListener? { get set }

    func switchToTab(at index: Int)
}

// MARK: - TabBarListener

public protocol TabBarListener: AnyObject {
    func routeToFollow(with recommendationId: Int)
    func routeToSetting()
    func routeToSearch()
    func routeToPopularTravel()
}

// MARK: - TabBarInteractor

final class TabBarInteractor: PresentableInteractor<TabBarPresentable>, TabBarInteractable {

    weak var router: TabBarRouting?
    weak var listener: TabBarListener?

    private let disposeBag = DisposeBag()

    override init(presenter: TabBarPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - TabBarPresentableListener

extension TabBarInteractor: TabBarPresentableListener {
}

// MARK: - HomeListener

extension TabBarInteractor: HomeListener {
    func homeDidTapPopularTravel() {
        listener?.routeToPopularTravel()
    }
    
    func homeDidTapFollowDetail(with recommendationId: Int) {
        listener?.routeToFollow(with: recommendationId)
    }
    
    func homeDidTapSearch() {
        listener?.routeToSearch()
    }
    
    func homeDidTapSetting() {
        listener?.routeToSetting()
    }

    func homeDidAddTrip(title: String, startDate: Date, endDate: Date) {
        presenter.switchToTab(at: 2)
    }
}

// MARK: - TravelToolListener

extension TabBarInteractor: TravelToolListener {
}
