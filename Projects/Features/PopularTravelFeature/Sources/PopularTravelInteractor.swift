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
    private let usecase: HomeUsecaseProtocol
    private let disposeBag = DisposeBag()
    
    private let popularTravelDataRelay = BehaviorRelay<PopularTravelPresentationModel?>(value: nil)
    private let selectedCategoryRelay = BehaviorRelay<Int?>(value: nil)
    
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
    }
    
    private func setupStream() {
        Observable.combineLatest(
            popularTravelDataRelay.compactMap { $0 },
            selectedCategoryRelay
        )
        .map { model, selectedId -> [PopularTravelSectionModel] in
            return [
                .init(section: .category, items: model.category.map {
                    .category($0, isSelected: $0.id == selectedId)
                }),
                .init(section: .popularTrip, items: model.popularTrip.map { .popularTrip($0) })
            ]
        }
        .subscribe(with: self) { owner, sections in
            owner.presenter.update(with: sections)
        }
        .disposed(by: disposeBag)
        
        popularTravelDataRelay
            .map { $0 == nil }
            .subscribe(with: self) { owner, isLoading in
                owner.presenter.setLoading(isLoading)
            }
            .disposed(by: disposeBag)
    }

    private func fetchData() {
        fetchDataTask?.cancel()
        
        presenter.setLoading(true)
        presenter.showErrorView(false)
        
        fetchDataTask = Task { [weak self] in
            guard let self, !Task.isCancelled else { return }
            
            do {
                async let categories = self.usecase.fetchCategoryList().map { $0.toPopularTravelModel() }
                async let populars = self.usecase.fetchPopularTripList().map { $0.toPopularTravelModel() }
                
                let model = try await PopularTravelPresentationModel(
                    category: categories,
                    popularTrip: populars
                )
                
                guard !Task.isCancelled else { return }
                
                if self.selectedCategoryRelay.value == nil, let firstId = model.category.first?.id {
                    self.selectedCategoryRelay.accept(firstId)
                }
                
                popularTravelDataRelay.accept(model)
                presenter.setLoading(false)
            } catch let error {
                presenter.setLoading(false)
                presenter.showErrorView(true)
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
        case .popularTrip(let trip):
            listener?.popularTravelDidTapFollowDetail(with: Int(trip.id) ?? 0)
        }
    }
    
    func reloadBtnTapped() {
        fetchData()
    }
}
