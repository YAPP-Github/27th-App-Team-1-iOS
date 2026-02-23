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
    func followDetailDidViewTrip()
}

// MARK: - FollowDetailPresentable

protocol FollowDetailPresentable: Presentable {
    var listener: FollowDetailPresentableListener? { get set }

    func showLoading()
    func hideLoading()
    func updateTravelDetail(_ detail: TravelDetail)
    func updatePlaces(_ places: [TravelPlace])
    func showPlaceDetail(_ place: TravelPlace)
    func showTripCreatedModal(onLater: @escaping () -> Void, onViewTrip: @escaping () -> Void)
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

    private let followDetailUsecase: FollowDetailUsecaseProtocol
    private let mode: FollowDetailMode

    private let disposeBag = DisposeBag()

    // MARK: - Data (Source of Truth)

    private var travelId: Int {
        switch mode {
        case .template(let id): return id
        case .myTravel(let id): return id
        }
    }
    private var travelDetail: TravelDetail?
    private var currentDay: Int = 1
    private var placesByDay: [Int: [TravelPlace]] = [:]

    init(
        presenter: FollowDetailPresentable,
        followDetailUsecase: FollowDetailUsecaseProtocol,
        mode: FollowDetailMode
    ) {
        self.followDetailUsecase = followDetailUsecase
        self.mode = mode
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
            await MainActor.run { presenter.showLoading() }

            do {
                let detail: TravelDetail
                let places: [TravelPlace]

                switch mode {
                case .template:
                    detail = try await followDetailUsecase.fetchTravelDetail(id: travelId)
                    places = try await followDetailUsecase.fetchPlaces(travelId: travelId, day: 1)
                case .myTravel:
                    detail = try await followDetailUsecase.fetchMyTravelDetail(id: travelId)
                    places = try await followDetailUsecase.fetchMyTravelPlaces(travelId: travelId, day: 1)
                }

                await MainActor.run {
                    self.travelDetail = detail
                    self.placesByDay[1] = places
                    presenter.updateTravelDetail(detail)
                    presenter.updatePlaces(places)
                    presenter.hideLoading()
                }
            } catch {
                print(error)
                await MainActor.run { presenter.hideLoading() }
            }
        }
    }

    private func loadPlaces(for day: Int) {
        if let cachedPlaces = placesByDay[day] {
            presenter.updatePlaces(cachedPlaces)
            return
        }

        Task {
            await MainActor.run { presenter.showLoading() }

            do {
                let places: [TravelPlace]

                switch mode {
                case .template:
                    places = try await followDetailUsecase.fetchPlaces(travelId: travelId, day: day)
                case .myTravel:
                    places = try await followDetailUsecase.fetchMyTravelPlaces(travelId: travelId, day: day)
                }

                await MainActor.run {
                    self.placesByDay[day] = places
                    presenter.updatePlaces(places)
                    presenter.hideLoading()
                }
            } catch {
                await MainActor.run { presenter.hideLoading() }
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
        switch mode {
        case .template:
            let totalDays = travelDetail?.days ?? 1
            router?.routeToTripCalendar(templateTotalDays: totalDays)
        case .myTravel:
            // 내 여행 수정 플로우 (추후 구현)
            break
        }
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
            templateId: travelId,
            startDate: startDate,
            endDate: endDate
        )

        Task {
            await MainActor.run {
                presenter.showLoading()
            }

            do {
                let response = try await followDetailUsecase.createUserTravel(request: request)

                await MainActor.run { [weak self] in
                    guard let self else { return }
                    presenter.hideLoading()

                    presenter.showTripCreatedModal(
                        onLater: { [weak self] in
                            self?.router?.detachTripCalendar()
                            self?.listener?.detachFollowDetail()
                        },
                        onViewTrip: { [weak self] in
                            self?.router?.detachTripCalendar()
                            self?.listener?.followDetailDidViewTrip()
                        }
                    )
                    print("여행 생성 성공 - userTravelId: \(response.userTravelId)")
                }
            } catch {
                await MainActor.run {
                    presenter.hideLoading()
                    router?.detachTripCalendar()
                    print(error)
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
