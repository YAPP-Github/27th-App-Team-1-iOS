//
//  TravelInteractor.swift
//  TravelFeature
//
//  Created by kimnahun on 2026-01-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import RIBs
import RxSwift

// MARK: - TravelListener

public protocol TravelListener: AnyObject {
}

// MARK: - TravelPresentable

protocol TravelPresentable: Presentable {
    var listener: TravelPresentableListener? { get set }

    func showLoading()
    func hideLoading()
    func updateTrips(_ trips: [UpcomingTrip])
}

// MARK: - TravelPresentableListener

protocol TravelPresentableListener: AnyObject {
    func didTapTrip(_ trip: UpcomingTrip)
    func viewWillAppear()
}

// MARK: - TravelInteractor

final class TravelInteractor: PresentableInteractor<TravelPresentable>, TravelInteractable {

    weak var router: TravelRouting?
    weak var listener: TravelListener?

    private let disposeBag = DisposeBag()

    // MARK: - Data (Source of Truth)

    private var trips: [UpcomingTrip] = []

    override init(presenter: TravelPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        loadTrips()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    // MARK: - Private Methods

    private func loadTrips() {
        presenter.showLoading()

        let mockTrips = [
            UpcomingTrip(
                id: 1,
                title: "바르셀로나 여행",
                thumbnailURL: "https://picsum.photos/400/300?random=1",
                startDate: createDate(month: 2, day: 1),
                endDate: createDate(month: 2, day: 12)
            ),
            UpcomingTrip(
                id: 2,
                title: "파리 여행",
                thumbnailURL: "https://picsum.photos/400/300?random=2",
                startDate: createDate(month: 3, day: 1),
                endDate: createDate(month: 3, day: 12)
            ),
            UpcomingTrip(
                id: 3,
                title: "런던 여행",
                thumbnailURL: "https://picsum.photos/400/300?random=3",
                startDate: createDate(month: 3, day: 13),
                endDate: createDate(month: 3, day: 23)
            )
        ]

        self.trips = mockTrips
        presenter.hideLoading()
        presenter.updateTrips(mockTrips)
    }

    private func createDate(month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = Calendar.current.component(.year, from: Date())
        components.month = month
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }

    // MARK: - Public Methods

    func addTrip(_ trip: UpcomingTrip) {
        trips.insert(trip, at: 0)
        presenter.updateTrips(trips)
    }
}

// MARK: - TravelPresentableListener

extension TravelInteractor: TravelPresentableListener {

    func viewWillAppear() {
        loadTrips()
    }

    func didTapTrip(_ trip: UpcomingTrip) {
    }
}
