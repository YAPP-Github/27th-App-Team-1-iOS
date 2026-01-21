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

    func updateMyTrips(_ trips: [MyTrip])
    func updatePopularTrips(_ trips: [PopularTrip])
    func updateRecommendations(_ recommendations: [Recommendation])
    func showLoading()
    func hideLoading()
}

// MARK: - HomeInteractor

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable {

    weak var router: HomeRouting?
    weak var listener: HomeListener?

    private let repository: TravelRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(presenter: HomePresentable, repository: TravelRepositoryProtocol) {
        self.repository = repository
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        loadHomeData()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    // MARK: - Private Methods

    private func loadHomeData() {
        presenter.showLoading()

        Task { @MainActor in
            async let myTrips = repository.fetchMyTrips()
            async let popularTrips = repository.fetchPopularTrips(category: .all)
            async let recommendations = repository.fetchRecommendations()

            let (myTripsData, popularTripsData, recommendationsData) = await (
                myTrips,
                popularTrips,
                recommendations
            )

            presenter.hideLoading()
            presenter.updateMyTrips(myTripsData)
            presenter.updatePopularTrips(popularTripsData)
            presenter.updateRecommendations(recommendationsData)
        }
    }
}

// MARK: - HomePresentableListener

extension HomeInteractor: HomePresentableListener {
    func didSelectCategory(_ category: TripCategory) {
        Task { @MainActor in
            let trips = await repository.fetchPopularTrips(category: category)
            presenter.updatePopularTrips(trips)
        }
    }

    func didTapRefresh() {
        loadHomeData()
    }
}
