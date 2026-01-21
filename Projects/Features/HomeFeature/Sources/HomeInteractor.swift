//
//  HomeInteractor.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import RIBs
import RxSwift

// MARK: - HomeListener

public protocol HomeListener: AnyObject {
    // 부모 RIB에 전달할 이벤트 정의
}

// MARK: - HomePresentable

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }

    func updateCategories(_ categories: [TripCategory], selectedIndex: Int)
    func updateMyTrips(_ trips: [MyTrip])
    func updatePopularTrips(_ trips: [PopularTrip])
    func updateRecommendations(_ recommendations: [Recommendation])
    func showLoading()
    func hideLoading()
}

// MARK: - HomePresentableListener

protocol HomePresentableListener: AnyObject {
    func didSelectCategory(at index: Int)
    func didSelectPopularTrip(at index: Int)
    func didSelectRecommendation(at index: Int)
    func didTapShowMoreTrips()
    func didTapAddButton()
    func didTapRefresh()
}

// MARK: - HomeInteractor

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable {

    weak var router: HomeRouting?
    weak var listener: HomeListener?

    private let repository: TravelRepositoryProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Data (Source of Truth)

    private let categories: [TripCategory] = TripCategory.allCases
    private var selectedCategoryIndex: Int = 0
    private var myTrips: [MyTrip] = []
    private var popularTrips: [PopularTrip] = []
    private var recommendations: [Recommendation] = []

    init(presenter: HomePresentable, repository: TravelRepositoryProtocol) {
        self.repository = repository
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        presenter.updateCategories(categories, selectedIndex: selectedCategoryIndex)
        loadHomeData()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    // MARK: - Private Methods

    private func loadHomeData() {
        presenter.showLoading()

        Task { @MainActor in
            async let myTripsResult = repository.fetchMyTrips()
            async let popularTripsResult = repository.fetchPopularTrips(category: categories[selectedCategoryIndex])
            async let recommendationsResult = repository.fetchRecommendations()

            let (myTripsData, popularTripsData, recommendationsData) = await (
                myTripsResult,
                popularTripsResult,
                recommendationsResult
            )

            self.myTrips = myTripsData
            self.popularTrips = popularTripsData
            self.recommendations = recommendationsData

            presenter.hideLoading()
            presenter.updateMyTrips(myTripsData)
            presenter.updatePopularTrips(popularTripsData)
            presenter.updateRecommendations(recommendationsData)
        }
    }

    private func loadPopularTrips(for category: TripCategory) {
        Task { @MainActor in
            let trips = await repository.fetchPopularTrips(category: category)
            self.popularTrips = trips
            presenter.updatePopularTrips(trips)
        }
    }
}

// MARK: - HomePresentableListener

extension HomeInteractor: HomePresentableListener {
    func didSelectCategory(at index: Int) {
        guard index != selectedCategoryIndex, index < categories.count else { return }
        selectedCategoryIndex = index
        presenter.updateCategories(categories, selectedIndex: index)
        loadPopularTrips(for: categories[index])
    }

    func didSelectPopularTrip(at index: Int) {
        guard index < popularTrips.count else { return }
        let trip = popularTrips[index]
        // TODO: 상세 화면으로 이동
        print("Selected popular trip: \(trip.title)")
    }

    func didSelectRecommendation(at index: Int) {
        guard index < recommendations.count else { return }
        let recommendation = recommendations[index]
        // TODO: 상세 화면으로 이동
        print("Selected recommendation: \(recommendation.title)")
    }

    func didTapShowMoreTrips() {
        // TODO: 더보기 화면으로 이동
        print("Show more trips tapped")
    }

    func didTapAddButton() {
        // TODO: 여행 추가 화면으로 이동
        print("Add button tapped")
    }

    func didTapRefresh() {
        loadHomeData()
    }
}
