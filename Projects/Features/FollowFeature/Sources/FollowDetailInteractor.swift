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
        Task { @MainActor in
            presenter.showLoading()

            // 여행 상세 정보 로드
            guard let detail = await repository.fetchTravelDetail(id: recommendationId) else {
                presenter.hideLoading()
                return
            }

            self.travelDetail = detail
            presenter.updateTravelDetail(detail)

            // 1일차 장소 로드
            await loadPlaces(for: 1)
            presenter.hideLoading()
        }
    }

    @MainActor
    private func loadPlaces(for day: Int) async {
        // 캐시된 데이터가 있으면 사용
        if let cachedPlaces = placesByDay[day] {
            presenter.updatePlaces(cachedPlaces)
            updateBudgetForDay(day)
            return
        }

        let places = await repository.fetchPlaces(travelId: recommendationId, day: day)
        placesByDay[day] = places

        presenter.updatePlaces(places)
        updateBudgetForDay(day)
    }

    @MainActor
    private func updateBudgetForDay(_ day: Int) {
        // 일차별 예산 계산 (전체 예산을 일수로 나눔 - Mock)
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

        Task { @MainActor in
            presenter.showLoading()
            await loadPlaces(for: day)
            presenter.hideLoading()
        }
    }

    func didSelectPlace(_ place: TravelPlace) {
        presenter.showPlaceDetail(place)
    }
}

// MARK: - TripCalendarListener

extension FollowDetailInteractor: TripCalendarListener {
    func tripCalendarDidSelectRange(startDate: Date, endDate: Date) {
        router?.detachTripCalendar()

        // TODO: 실제 여행 저장 API 호출
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print("Trip added: \(formatter.string(from: startDate)) ~ \(formatter.string(from: endDate))")
    }

    func tripCalendarDidCancel() {
        router?.detachTripCalendar()
    }
}
