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
    func updateWeather(_ state: TravelToolWeatherState)
}

// MARK: - TravelToolPresentableListener

protocol TravelToolPresentableListener: AnyObject {
    func viewWillAppear()
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
            guard let self else { return }

            // 1. 여행 정보 조회
            var summary: MyTripSummary?
            do {
                summary = try await self.usecase.fetchMyTripInfo()
            } catch {
                summary = nil
            }

            guard !Task.isCancelled else { return }

            // 2. 트립 카드 업데이트
            let tripState: TravelToolTripState
            if let summary {
                tripState = self.convertToState(summary)
            } else {
                tripState = .empty
            }

            await MainActor.run { [tripState] in
                self.presenter.updateTripCard(tripState)
            }

            // 3. 여행이 없으면 noTrip 상태
            guard let summary else {
                await MainActor.run {
                    self.presenter.updateWeather(.noTrip)
                }
                return
            }

            guard !Task.isCancelled else { return }

            // 4. 여행 기간 일수 계산
            let calendar = Calendar.current
            let startOfToday = calendar.startOfDay(for: Date())
            let startOfEnd = calendar.startOfDay(for: summary.endDay)
            let daysFromToday = (calendar.dateComponents([.day], from: startOfToday, to: startOfEnd).day ?? 0) + 1

            guard daysFromToday > 0 else {
                await MainActor.run {
                    self.presenter.updateWeather(.preparing)
                }
                return
            }

            // 5. 날씨 예보 조회
            let forecastDays = min(daysFromToday, 10)
            var forecasts: [DailyWeatherInfo]?

            do {
                let all = try await self.weatherRepository.fetchForecast(
                    latitude: summary.tripSchedule.latitude,
                    longitude: summary.tripSchedule.longitude,
                    days: forecastDays
                )

                let startOfTravel = calendar.startOfDay(for: summary.startDay)
                let endOfTravel = calendar.startOfDay(for: summary.endDay)

                let filtered = all.filter { info in
                    let day = calendar.startOfDay(for: info.date)
                    return day >= startOfTravel && day <= endOfTravel
                }

                forecasts = filtered.isEmpty ? nil : filtered
            } catch {
                forecasts = nil
            }

            guard !Task.isCancelled else { return }

            // 6. 날씨 뷰 업데이트
            let city = summary.city
            await MainActor.run { [forecasts] in
                if let forecasts {
                    self.presenter.updateWeather(
                        .hasWeather(title: city, forecasts: forecasts)
                    )
                } else {
                    self.presenter.updateWeather(.preparing)
                }
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
    func viewWillAppear() {
        fetchTripInfo()
    }
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
