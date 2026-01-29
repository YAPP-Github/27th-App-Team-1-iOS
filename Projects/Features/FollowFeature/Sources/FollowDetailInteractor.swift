//
//  FollowDetailInteractor.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation
import RIBs
import RxSwift

// MARK: - FollowDetailListener

public protocol FollowDetailListener: AnyObject {
    func followDetailDidTapClose()
    func followDetailDidAddTrip(title: String, startDate: Date, endDate: Date)
}

// MARK: - FollowDetailPresentable

protocol FollowDetailPresentable: Presentable {
    var listener: FollowDetailPresentableListener? { get set }

    func showLoading()
    func hideLoading()
    func updateTravelDetail(_ detail: TravelDetail)
    func updatePlaces(_ places: [TravelPlace])
    func updateBudget(_ budget: Int)
    func showPlaceDetail(_ place: TravelPlace)
}

// MARK: - FollowDetailPresentableListener

protocol FollowDetailPresentableListener: AnyObject {
    func didTapCloseButton()
    func didTapAddToTrip()
    func didSelectDay(_ day: Int)
    func didSelectPlace(_ place: TravelPlace)
}

// MARK: - FollowDetailInteractor

final class FollowDetailInteractor: PresentableInteractor<FollowDetailPresentable>, FollowDetailInteractable {

    weak var router: FollowDetailRouting?
    weak var listener: FollowDetailListener?

    private let repository: FollowRepositoryProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Data (Source of Truth)

    private let recommendationId: Int
    private var travelDetail: TravelDetail?
    private var currentDay: Int = 1
    private var placesByDay: [Int: [TravelPlace]] = [:]

    init(
        presenter: FollowDetailPresentable,
        repository: FollowRepositoryProtocol,
        recommendationId: Int
    ) {
        self.repository = repository
        self.recommendationId = recommendationId
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        loadTravelDetail()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    // MARK: - Private Methods

    private func loadTravelDetail() {
        Task {
            await MainActor.run {
                presenter.showLoading()
            }

            guard let detail = await repository.fetchTravelDetail(id: recommendationId) else {
                await MainActor.run {
                    presenter.hideLoading()
                }
                return
            }

            let places = await repository.fetchPlaces(travelId: recommendationId, day: 1)

            await MainActor.run {
                self.travelDetail = detail
                self.placesByDay[1] = places
                presenter.updateTravelDetail(detail)
                presenter.updatePlaces(places)
                updateBudgetForDay(1)
                presenter.hideLoading()
            }
        }
    }

    private func loadPlaces(for day: Int) {
        if let cachedPlaces = placesByDay[day] {
            presenter.updatePlaces(cachedPlaces)
            updateBudgetForDay(day)
            return
        }

        Task {
            await MainActor.run {
                presenter.showLoading()
            }

            let places = await repository.fetchPlaces(travelId: recommendationId, day: day)

            await MainActor.run {
                self.placesByDay[day] = places
                presenter.updatePlaces(places)
                updateBudgetForDay(day)
                presenter.hideLoading()
            }
        }
    }

    private func updateBudgetForDay(_ day: Int) {
        guard let detail = travelDetail else { return }
        let dailyBudget = detail.budgetPerPerson / detail.days
        presenter.updateBudget(dailyBudget)
    }
}

// MARK: - FollowDetailPresentableListener

extension FollowDetailInteractor: FollowDetailPresentableListener {
    func didTapCloseButton() {
        listener?.followDetailDidTapClose()
    }

    func didTapAddToTrip() {
        router?.routeToTripCalendar()
    }

    func didSelectDay(_ day: Int) {
        guard day != currentDay else { return }
        currentDay = day
        loadPlaces(for: day)
    }

    func didSelectPlace(_ place: TravelPlace) {
        presenter.showPlaceDetail(place)
    }
}

// MARK: - TripCalendarListener

extension FollowDetailInteractor: TripCalendarListener {
    func tripCalendarDidSelectRange(startDate: Date, endDate: Date) {
        router?.detachTripCalendar()

        // 여행 제목 (city + "여행")
        let tripTitle = "\(travelDetail?.city ?? "새로운") 여행"

        // Home으로 돌아가면서 Travel 탭으로 이동하도록 알림
        listener?.followDetailDidAddTrip(title: tripTitle, startDate: startDate, endDate: endDate)
    }

    func tripCalendarDidCancel() {
        router?.detachTripCalendar()
    }
}
