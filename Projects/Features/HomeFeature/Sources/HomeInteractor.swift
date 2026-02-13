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
        
        setupStream()
        fetchHomeData()
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
        
        homeDataRelay
            .map { $0 == nil }
            .subscribe(with: self) { owner, isLoading in
                owner.presenter.setLoading(isLoading)
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchHomeData() {
        fetchDataTask?.cancel()
        
        presenter.setLoading(true)
        presenter.showErrorView(false)
        
        fetchDataTask = Task { [weak self] in
            guard let self, !Task.isCancelled else { return }
            
            do {
                let myTripBanner: HomePresentationModel.Banner = await {
                    do {
                        return try await self.usecase.fetchMyTripInfo().toPresention()
                    } catch {
                        
                        return .empty
                    }
                }()
                
                async let categories = self.usecase.fetchCategoryList().map { $0.toHomeModel() }
                async let populars = self.usecase.fetchPopularTripList().map { $0.toPopularHomeModel() }
                async let recommended = self.usecase.fetchRecommendTripList().map { $0.toRecommendHomeModel() }
                
                let model = try await HomePresentationModel(
                    banner: myTripBanner,
                    category: categories,
                    popularTrip: populars,
                    recommendedTrip: recommended
                )
                
                guard !Task.isCancelled else { return }
                
                if self.selectedCategoryRelay.value == nil, let firstId = model.category.first?.id {
                    self.selectedCategoryRelay.accept(firstId)
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
}

// MARK: - HomePresentableListener
extension HomeInteractor: HomePresentableListener {
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
            selectedCategoryRelay.accept(category.id)
        case .popularTrip(let trip):
            listener?.homeDidTapFollowDetail(with: Int(trip.id) ?? 2)
        case .recommendedTrip(let trip):
            listener?.homeDidTapFollowDetail(with: Int(trip.id) ?? 2)
        default: break
        }
    }
    
    func moreBtnTapped() {
        listener?.homeDidTapPopularTravel()
    }
}
