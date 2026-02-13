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
    func detachFollowDetail()
    func followDetailDidAddTrip(title: String, startDate: Date, endDate: Date)
}

// MARK: - FollowDetailPresentable

protocol FollowDetailPresentable: Presentable {
    var listener: FollowDetailPresentableListener? { get set }

    func showLoading()
    func hideLoading()
    func updateTravelDetail(_ detail: TravelDetail)
    func updatePlaces(_ places: [TravelPlace])
    func showPlaceDetail(_ place: TravelPlace)
}

// MARK: - FollowDetailPresentableListener

protocol FollowDetailPresentableListener: AnyObject {
    func detachFollowDetail()
    func didTapAddToTrip()
    func didSelectDay(_ day: Int)
    func didSelectPlace(_ place: TravelPlace)
    func didTapPlaceDetailChevron(_ place: TravelPlace)
}

// MARK: - FollowDetailInteractor

final class FollowDetailInteractor: PresentableInteractor<FollowDetailPresentable>, FollowDetailInteractable {

    weak var router: FollowDetailRouting?
    weak var listener: FollowDetailListener?

    private let followService: FollowServiceProtocol
    private let travelService: TravelServiceProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Data (Source of Truth)

    private let recommendationId: Int
    private var travelDetail: TravelDetail?
    private var currentDay: Int = 1
    private var placesByDay: [Int: [TravelPlace]] = [:]

    init(
        presenter: FollowDetailPresentable,
        followService: FollowServiceProtocol,
        travelService: TravelServiceProtocol,
        recommendationId: Int
    ) {
        self.followService = followService
        self.travelService = travelService
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

            let detailResult = await followService.fetchTravelDetail(id: recommendationId)

            guard case .success(let detail) = detailResult else {
                await MainActor.run {
                    presenter.hideLoading()
                }
                return
            }

            let placesResult = await followService.fetchPlaces(travelId: recommendationId, day: 1)
            let places = (try? placesResult.get()) ?? []

            await MainActor.run {
                self.travelDetail = detail
                self.placesByDay[1] = places
                presenter.updateTravelDetail(detail)
                presenter.updatePlaces(places)
                presenter.hideLoading()
            }
        }
    }

    private func loadPlaces(for day: Int) {
        if let cachedPlaces = placesByDay[day] {
            presenter.updatePlaces(cachedPlaces)
            return
        }

        Task {
            await MainActor.run {
                presenter.showLoading()
            }

            let result = await followService.fetchPlaces(travelId: recommendationId, day: day)
            let places = (try? result.get()) ?? []

            await MainActor.run {
                self.placesByDay[day] = places
                presenter.updatePlaces(places)
                presenter.hideLoading()
            }
        }
    }
}

// MARK: - FollowDetailPresentableListener

extension FollowDetailInteractor: FollowDetailPresentableListener {
    func detachFollowDetail() {
        listener?.detachFollowDetail()
    }

    func didTapAddToTrip() {
        let totalDays = travelDetail?.days ?? 1
        router?.routeToTripCalendar(templateTotalDays: totalDays)
    }

    func didSelectDay(_ day: Int) {
        guard day != currentDay else { return }
        currentDay = day
        loadPlaces(for: day)
    }

    func didSelectPlace(_ place: TravelPlace) {
        presenter.showPlaceDetail(place)
    }

    func didTapPlaceDetailChevron(_ place: TravelPlace) {
        let youtuberName = travelDetail?.youtube.youtuber ?? ""
        router?.routeToPlaceDetail(travelPlace: place, youtuberName: youtuberName)
    }
}

// MARK: - PlaceDetailListener

extension FollowDetailInteractor: PlaceDetailListener {
    func placeDetailDidTapBack() {
        router?.detachPlaceDetail()
    }
}

// MARK: - TripCalendarListener

extension FollowDetailInteractor: TripCalendarListener {
    func tripCalendarDidSelectRange(startDate: Date, endDate: Date) {
        createUserTravel(startDate: startDate, endDate: endDate)
    }

    func tripCalendarDidCancel() {
        router?.detachTripCalendar()
    }

    private func createUserTravel(startDate: Date, endDate: Date) {
        let request = CreateTravelRequest(
            templateId: recommendationId,
            startDate: startDate,
            endDate: endDate
        )

        Task {
            await MainActor.run {
                presenter.showLoading()
            }

            let result = await travelService.createUserTravel(request: request)

            await MainActor.run {
                presenter.hideLoading()
                router?.detachTripCalendar()

                switch result {
                case .success(let response):
                    let tripTitle = "\(travelDetail?.city ?? "새로운") 여행"
                    listener?.followDetailDidAddTrip(title: tripTitle, startDate: startDate, endDate: endDate)
                    print("여행 생성 성공 - userTravelId: \(response.userTravelId)")

                case .failure(let error):
                    handleCreateTravelError(error)
                }
            }
        }
    }

    private func handleCreateTravelError(_ error: CreateTravelError) {
        switch error {
        case .validationFailed(let field, let message):
            print("유효성 검증 실패 - \(field): \(message)")
        case .invalidDateOrder(let message):
            print("날짜 순서 오류: \(message)")
        case .notFoundTemplate(let message):
            print("템플릿 없음: \(message)")
        case .unknown(let code, let message):
            print("알 수 없는 오류 (\(code)): \(message)")
        }
    }
}
