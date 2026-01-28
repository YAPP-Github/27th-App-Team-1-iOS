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

// MARK: - TabBarListener

public protocol TabBarListener: AnyObject {
}

// MARK: - TabBarPresentable

protocol TabBarPresentable: Presentable {
    var listener: TabBarPresentableListener? { get set }

    func switchToTab(at index: Int)
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

    func homeDidAddTrip(title: String, startDate: Date, endDate: Date) {
        presenter.switchToTab(at: 2)
    }
}
