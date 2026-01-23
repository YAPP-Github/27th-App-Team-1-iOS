//
//  HomeInteractor.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import FollowFeature
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
    func updatePopularTrips(_ tripsByCategory: [TripCategory: [PopularTrip]], categories: [TripCategory])
    func updateRecommendations(_ recommendations: [Recommendation])
    func scrollToCategory(at index: Int)
    func showLoading()
    func hideLoading()
}

// MARK: - HomePresentableListener

protocol HomePresentableListener: AnyObject {
    func didSelectCategory(at index: Int)
    func didScrollToCategory(at index: Int)
    func didSelectPopularTrip(at index: Int, in section: Int)
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
    private var tripsByCategory: [TripCategory: [PopularTrip]] = [:]
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
            async let tripsByCategoryResult = repository.fetchAllPopularTrips()
            async let recommendationsResult = repository.fetchRecommendations()

            let (myTripsData, tripsByCategoryData, recommendationsData) = await (
                myTripsResult,
                tripsByCategoryResult,
                recommendationsResult
            )

            self.myTrips = myTripsData
            self.tripsByCategory = tripsByCategoryData
            self.recommendations = recommendationsData

            presenter.hideLoading()
            presenter.updateMyTrips(myTripsData)
            presenter.updatePopularTrips(tripsByCategoryData, categories: categories)
            presenter.updateRecommendations(recommendationsData)
        }
    }
}

// MARK: - HomePresentableListener

extension HomeInteractor: HomePresentableListener {
    func didSelectCategory(at index: Int) {
        guard index != selectedCategoryIndex, index < categories.count else { return }
        selectedCategoryIndex = index
        presenter.updateCategories(categories, selectedIndex: index)
        presenter.scrollToCategory(at: index)
    }

    func didScrollToCategory(at index: Int) {
        guard index != selectedCategoryIndex, index < categories.count else { return }
        selectedCategoryIndex = index
        presenter.updateCategories(categories, selectedIndex: index)
    }

    func didSelectPopularTrip(at index: Int, in section: Int) {
        guard section < categories.count else { return }
        let category = categories[section]
        guard let trips = tripsByCategory[category], index < trips.count else { return }
        let trip = trips[index]
        // TODO: 상세 화면으로 이동
        print("Selected popular trip: \(trip.title)")
    }

    func didSelectRecommendation(at index: Int) {
        guard index < recommendations.count else { return }
        let recommendation = recommendations[index]
        router?.routeToFollowDetail(with: recommendation.id)
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

// MARK: - FollowDetailListener

extension HomeInteractor: FollowDetailListener {
    func followDetailDidTapClose() {
        router?.detachFollowDetail()
    }
}
