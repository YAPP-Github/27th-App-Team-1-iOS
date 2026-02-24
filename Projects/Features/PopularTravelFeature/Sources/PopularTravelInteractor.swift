//
//  PopularTravelInteractor.swift
//  PopularTravelFeature
//
//  Created by 최안용 on 2/12/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain

import RIBs
import RxCocoa
import RxRelay
import RxSwift

struct PopularTravelSectionModel {
    let section: PopularTravelSectionKind
    let items: [PopularTravelItem]
}

public protocol PopularTravelRouting: ViewableRouting {
    
}

protocol PopularTravelPresentable: Presentable {
    var listener: PopularTravelPresentableListener? { get set }
    
    func update(with sections: [PopularTravelSectionModel])
    func setLoading(_ isLoading: Bool)
    func showErrorView(_ isError: Bool)
}

public protocol PopularTravelListener: AnyObject {
    func popularTravelDidTapFollowDetail(with recommendationId: Int)
    func popularTravelDidTapSearch()
    func detachPopularTravel()
}

final class PopularTravelInteractor: PresentableInteractor<PopularTravelPresentable>, PopularTravelInteractable {

    weak var router: PopularTravelRouting?
    weak var listener: PopularTravelListener?

    private var fetchDataTask: Task<Void, Never>?
    private var fetchTripsTask: Task<Void, Never>?
    private let usecase: HomeUsecaseProtocol
    private let disposeBag = DisposeBag()

    private let categoriesRelay = BehaviorRelay<[PopularTravelPresentationModel.Category]>(value: [])
    private let popularTripsRelay = BehaviorRelay<[PopularTravelPresentationModel.PopularTrip]>(value: [])
    private let selectedCategoryRelay = BehaviorRelay<Int?>(value: nil)
    private let isLoadingRelay = BehaviorRelay<Bool>(value: true)
    
    init(presenter: PopularTravelPresentable, usecase: HomeUsecaseProtocol) {
        self.usecase = usecase
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        setupStream()
        fetchData()
    }

    override func willResignActive() {
        super.willResignActive()

        fetchDataTask?.cancel()
        fetchDataTask = nil
        fetchTripsTask?.cancel()
        fetchTripsTask = nil
    }

    private func setupStream() {
        Observable.combineLatest(
            categoriesRelay,
            popularTripsRelay,
            selectedCategoryRelay
        )
        .map { categories, popularTrips, selectedId -> [PopularTravelSectionModel] in
            return [
                .init(section: .category, items: categories.map {
                    .category($0, isSelected: $0.id == selectedId)
                }),
                .init(section: .popularTrip, items: popularTrips.map { .popularTrip($0) })
            ]
        }
        .subscribe(with: self) { owner, sections in
            owner.presenter.update(with: sections)
        }
        .disposed(by: disposeBag)

        isLoadingRelay
            .subscribe(with: self) { owner, isLoading in
                owner.presenter.setLoading(isLoading)
            }
            .disposed(by: disposeBag)
    }

    private func fetchData() {
        fetchDataTask?.cancel()

        isLoadingRelay.accept(true)
        presenter.showErrorView(false)

        fetchDataTask = Task { [weak self] in
            guard let self, !Task.isCancelled else { return }

            do {
                async let categories = self.usecase.fetchCategoryList().map { $0.toPopularTravelModel() }
                async let populars = self.usecase.fetchPopularTripList().map { $0.toPopularTravelModel() }

                let (cats, trips) = try await (categories, populars)

                guard !Task.isCancelled else { return }

                if self.selectedCategoryRelay.value == nil, let firstId = cats.first?.id {
                    self.selectedCategoryRelay.accept(firstId)
                }

                self.categoriesRelay.accept(cats)
                self.popularTripsRelay.accept(trips)
                self.isLoadingRelay.accept(false)
            } catch {
                self.isLoadingRelay.accept(false)
                self.presenter.showErrorView(true)
            }
        }
    }

    private func fetchPopularTrips(categoryId: Int) {
        fetchTripsTask?.cancel()

        fetchTripsTask = Task { [weak self] in
            guard let self, !Task.isCancelled else { return }

            do {
                let trips = try await self.usecase.fetchPopularTripList(id: categoryId).map { $0.toPopularTravelModel() }
                guard !Task.isCancelled else { return }
                self.popularTripsRelay.accept(trips)
            } catch {
                // 카테고리 필터 실패 시 기존 목록 유지
            }
        }
    }
}

extension PopularTravelInteractor: PopularTravelPresentableListener {
    func detachPopularTravel() {
        listener?.detachPopularTravel()
    }
    
    func searchBtnTapped() {
        listener?.popularTravelDidTapSearch()
    }
    
    func itemSelected(item: PopularTravelItem) {
        switch item {
        case .category(let category, _):
            selectedCategoryRelay.accept(category.id)
            fetchPopularTrips(categoryId: category.id)
        case .popularTrip(let trip):
            listener?.popularTravelDidTapFollowDetail(with: trip.id)
        }
    }
    
    func reloadBtnTapped() {
        fetchData()
    }
}
