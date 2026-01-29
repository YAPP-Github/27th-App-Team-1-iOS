//
//  TripCalendarInteractor.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import RIBs
import RxSwift

// MARK: - TripCalendarListener

protocol TripCalendarListener: AnyObject {
    func tripCalendarDidSelectRange(startDate: Date, endDate: Date)
    func tripCalendarDidCancel()
}

// MARK: - TripCalendarPresentable

protocol TripCalendarPresentable: Presentable {
    var listener: TripCalendarPresentableListener? { get set }
}

// MARK: - TripCalendarPresentableListener

protocol TripCalendarPresentableListener: AnyObject {
    func didTapBackButton()
    func didTapCompleteButton(startDate: Date, endDate: Date)
}

// MARK: - TripCalendarInteractor

final class TripCalendarInteractor: PresentableInteractor<TripCalendarPresentable>, TripCalendarInteractable {

    weak var router: TripCalendarRouting?
    weak var listener: TripCalendarListener?

    override init(presenter: TripCalendarPresentable) {
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

// MARK: - TripCalendarPresentableListener

extension TripCalendarInteractor: TripCalendarPresentableListener {
    func didTapBackButton() {
        listener?.tripCalendarDidCancel()
    }

    func didTapCompleteButton(startDate: Date, endDate: Date) {
        listener?.tripCalendarDidSelectRange(startDate: startDate, endDate: endDate)
    }
}
