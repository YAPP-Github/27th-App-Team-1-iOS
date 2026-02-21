//
//  TravelToolInteractor.swift
//  TravelToolFeature
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain
import RIBs
import RxSwift

// MARK: - TravelToolListener

public protocol TravelToolListener: AnyObject {
}

// MARK: - TravelToolPresentable

protocol TravelToolPresentable: Presentable {
    var listener: TravelToolPresentableListener? { get set }

    func updateTripCard(_ state: TravelToolTripState)
    func updateWeather(_ info: WeatherInfo?)
}

// MARK: - TravelToolPresentableListener

protocol TravelToolPresentableListener: AnyObject {
}

// MARK: - TravelToolInteractor

final class TravelToolInteractor: PresentableInteractor<TravelToolPresentable>, TravelToolInteractable {

    weak var router: TravelToolRouting?
    weak var listener: TravelToolListener?

    private let usecase: HomeUsecaseProtocol
    private let weatherRepository: WeatherRepositoryInterface
    private var fetchTask: Task<Void, Never>?
    private let disposeBag = DisposeBag()

    init(
        presenter: TravelToolPresentable,
        usecase: HomeUsecaseProtocol,
        weatherRepository: WeatherRepositoryInterface
    ) {
        self.usecase = usecase
        self.weatherRepository = weatherRepository
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()

        fetchTripInfo()
    }

    override func willResignActive() {
        super.willResignActive()

        fetchTask?.cancel()
        fetchTask = nil
    }

    private func fetchTripInfo() {
        fetchTask?.cancel()

        fetchTask = Task { [weak self] in
            guard let self, !Task.isCancelled else { return }

            let summary: MyTripSummary? = await {
                do {
                    return try await self.usecase.fetchMyTripInfo()
                } catch {
                    return nil
                }
            }()

            guard !Task.isCancelled else { return }

            let state: TravelToolTripState
            if let summary {
                state = self.convertToState(summary)
            } else {
                state = .empty
            }

            await MainActor.run {
                self.presenter.updateTripCard(state)
            }

            guard let summary, !Task.isCancelled else {
                await MainActor.run { self.presenter.updateWeather(nil) }
                return
            }

            let weatherInfo: WeatherInfo? = await {
                do {
                    return try await self.weatherRepository.fetchCurrentWeather(
                        latitude: summary.tripSchedule.latitude,
                        longitude: summary.tripSchedule.longitude
                    )
                } catch {
                    return nil
                }
            }()

            guard !Task.isCancelled else { return }
            await MainActor.run {
                self.presenter.updateWeather(weatherInfo)
            }
        }
    }

    private func convertToState(_ summary: MyTripSummary) -> TravelToolTripState {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startOfTravel = calendar.startOfDay(for: summary.startDay)
        let startOfEnd = calendar.startOfDay(for: summary.endDay)

        let duration = "\(summary.startDay.toTravelToolKoreanMMdd())~\(summary.endDay.toTravelToolKoreanMMdd())"

        if startOfToday >= startOfTravel && startOfToday <= startOfEnd {
            let schedule = summary.tripSchedule
            return .onGoing(
                title: "\(summary.title) \(schedule.day)일차 입니다!",
                date: duration,
                duration: "\(schedule.estimatedDuration)분",
                place: schedule.placeName,
                imageUrl: schedule.thumbnailUrl
            )
        } else if startOfToday < startOfTravel {
            let dDayValue = calendar.dateComponents([.day], from: startOfToday, to: startOfTravel).day ?? 0
            return .upComing(
                title: summary.title,
                date: duration,
                dDay: dDayValue,
                imageUrl: summary.tripSchedule.thumbnailUrl
            )
        } else {
            return .empty
        }
    }
}

// MARK: - TravelToolPresentableListener

extension TravelToolInteractor: TravelToolPresentableListener {
}

// MARK: - Date Extension

extension Date {
    func toTravelToolKoreanMMdd() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: self)
    }
}
