//
//  HomeInteractor.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain

import RIBs
import RxCocoa
import RxRelay
import RxSwift

struct HomeSectionModel {
    let section: HomeSectionKind
    let items: [HomeItem]
}

// MARK: - HomeRouting
public protocol HomeRouting: ViewableRouting {
    
}

// MARK: - HomePresentable
protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
    
    func update(with sections: [HomeSectionModel])
    func setLoading(_ isLoading: Bool)
    func showErrorView(_ isError: Bool)
}

// MARK: - HomeListener
public protocol HomeListener: AnyObject {
    func homeDidTapFollowDetail(with recommendationId: Int)
    func homeDidTapSearch()
    func homeDidTapSetting()
    func homeDidTapPopularTravel()
}

// MARK: - HomeInteractor

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable {
    weak var router: HomeRouting?
    weak var listener: HomeListener?

    private var fetchDataTask: Task<Void, Never>?
    private let usecase: HomeUsecaseProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Data (Source of Truth)
    private let homeDataRelay = BehaviorRelay<HomePresentationModel?>(value: nil)
    private let selectedCategoryRelay = BehaviorRelay<Int?>(value: nil)

    init(presenter: HomePresentable, usecase: HomeUsecaseProtocol) {
        self.usecase = usecase
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
        
        fetchDataTask?.cancel()
        fetchDataTask = nil
    }

    private func setupStream() {
        Observable.combineLatest(
            homeDataRelay.compactMap { $0 },
            selectedCategoryRelay
        )
        .map { model, selectedId -> [HomeSectionModel] in
            return [
                .init(section: .banner, items: [.banner(model.banner)]),
                .init(section: .category, items: model.category.map {
                    .category($0, isSelected: $0.id == selectedId)
                }),
                .init(section: .popularTrip, items: model.popularTrip.map { .popularTrip($0) }),
                .init(section: .recommendedTrip, items: model.recommendedTrip.map { .recommendedTrip($0) })
            ]
        }
        .subscribe(with: self) { owner, sections in
            owner.presenter.update(with: sections)
        }
        .disposed(by: disposeBag)
    }
    
    private static let allCategoryId = -1

    private func fetchHomeData() {
        fetchDataTask?.cancel()

        presenter.setLoading(true)
        presenter.showErrorView(false)

        fetchDataTask = Task { [weak self] in
            guard let self, !Task.isCancelled else { return }

            do {
                let usecase = self.usecase
                var myTripBanner: HomePresentationModel.Banner
                do {
                    let tripInfo = try await usecase.fetchMyTripInfo()
                    myTripBanner = tripInfo.toPresention()
                } catch {
                    myTripBanner = .empty
                }

                let allCategory = HomePresentationModel.Category(
                    id: HomeInteractor.allCategoryId,
                    creator: "전체",
                    viedoType: .none
                )

                async let apiCategories = self.usecase.fetchCategoryList().map { $0.toHomeModel() }
                async let populars = self.usecase.fetchPopularTripList(id: nil).map { $0.toPopularHomeModel() }
                async let recommended = self.usecase.fetchRecommendTripList().map { $0.toRecommendHomeModel() }

                let categories = try await [allCategory] + apiCategories

                let model = try await HomePresentationModel(
                    banner: myTripBanner,
                    category: categories,
                    popularTrip: populars,
                    recommendedTrip: recommended
                )

                guard !Task.isCancelled else { return }

                if self.selectedCategoryRelay.value == nil {
                    self.selectedCategoryRelay.accept(HomeInteractor.allCategoryId)
                }

                homeDataRelay.accept(model)
                presenter.setLoading(false)
            } catch let error {
                print(error)
                presenter.setLoading(false)
                presenter.showErrorView(true)
            }
        }
    }

    private func fetchPopularTrips(categoryId: Int) {
        Task { [weak self] in
            guard let self else { return }

            do {
                let apiId: Int? = categoryId == HomeInteractor.allCategoryId ? nil : categoryId
                let populars = try await self.usecase.fetchPopularTripList(id: apiId).map { $0.toPopularHomeModel() }

                guard !Task.isCancelled, let model = self.homeDataRelay.value else { return }

                let updated = HomePresentationModel(
                    banner: model.banner,
                    category: model.category,
                    popularTrip: populars,
                    recommendedTrip: model.recommendedTrip
                )
                self.homeDataRelay.accept(updated)
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - HomePresentableListener
extension HomeInteractor: HomePresentableListener {
    func viewDidLoad() {
        setupStream()
        fetchHomeData()
    }

    func reloadBtnTapped() {
        fetchHomeData()
    }
    
    func searchBtnTapped() {
        listener?.homeDidTapSearch()
    }
    
    func settingBtnTapped() {
        listener?.homeDidTapSetting()
    }
    
    func itemSelected(item: HomeItem) {
        switch item {
        case .category(let category, _):
            let categoryId = category.id
            guard categoryId != selectedCategoryRelay.value else { return }
            selectedCategoryRelay.accept(categoryId)
            fetchPopularTrips(categoryId: categoryId)
        case .popularTrip(let trip):
            listener?.homeDidTapFollowDetail(with: trip.id)
        case .recommendedTrip(let trip):
            listener?.homeDidTapFollowDetail(with: trip.id)
        default: break
        }
    }
    
    func moreBtnTapped() {
        listener?.homeDidTapPopularTravel()
    }
}
