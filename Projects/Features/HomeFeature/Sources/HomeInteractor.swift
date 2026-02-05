//
//  HomeInteractor.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import FollowFeature
import Foundation
import RIBs
import RxSwift

// MARK: - HomeListener

public protocol HomeListener: AnyObject {
    func homeDidAddTrip(title: String, startDate: Date, endDate: Date)
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

    private let homeService: HomeServiceProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Data (Source of Truth)

    private let categories: [TripCategory] = TripCategory.allCases
    private var selectedCategoryIndex: Int = 0
    private var myTrips: [MyTrip] = []
    private var tripsByCategory: [TripCategory: [PopularTrip]] = [:]
    private var recommendations: [Recommendation] = []

    init(presenter: HomePresentable, homeService: HomeServiceProtocol) {
        self.homeService = homeService
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
        Task {
            await MainActor.run {
                presenter.showLoading()
            }

            async let myTripsResult = homeService.fetchMyTrips()
            async let tripsByCategoryResult = homeService.fetchAllPopularTrips()
            async let recommendationsResult = homeService.fetchRecommendations()

            let (myTripsData, tripsByCategoryData, recommendationsData) = await (
                (try? myTripsResult.get()) ?? [],
                (try? tripsByCategoryResult.get()) ?? [:],
                (try? recommendationsResult.get()) ?? []
            )

            await MainActor.run {
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
        // TODO: 실제 API 연동 시 trip.id 사용
        // 현재는 테스트를 위해 항상 id 1로 이동
        router?.routeToFollowDetail(with: 1)
    }

    func didSelectRecommendation(at index: Int) {
        guard index < recommendations.count else { return }
        // TODO: 실제 API 연동 시 recommendation.id 사용
        // 현재는 테스트를 위해 항상 id 1로 이동
        router?.routeToFollowDetail(with: 1)
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

    func followDetailDidAddTrip(title: String, startDate: Date, endDate: Date) {
        router?.detachFollowDetail()
        // TabBar에 알려서 Travel 탭으로 이동
        listener?.homeDidAddTrip(title: title, startDate: startDate, endDate: endDate)
    }
}
