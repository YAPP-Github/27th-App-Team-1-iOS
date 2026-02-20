//
//  SearchResultInteractor.swift
//  SearchFeature
//
//  Created by 최안용 on 2/18/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain

import RIBs
import RxCocoa
import RxRelay
import RxSwift

protocol SearchResultRouting: ViewableRouting {
    
}

protocol SearchResultPresentable: Presentable {
    var listener: SearchResultPresentableListener? { get set }
    
    func update(with model: SearchResultPresentationModel)
    func setLoading(_ isLoading: Bool)
    func showErrorView(_ isError: Bool)
}

protocol SearchResultListener: AnyObject {
    func detachSearchResult()
    func popularTravelDidTapFollowDetail(with recommendationId: Int)
}

final class SearchResultInteractor: PresentableInteractor<SearchResultPresentable>, SearchResultInteractable {
    weak var router: SearchResultRouting?
    weak var listener: SearchResultListener?

    private let searchKeyword: String
    private let usecase: TemplatesSearchUsecaseProtocol
    private var fetchDataTask: Task<Void, Never>?
    private let disposeBag = DisposeBag()
    
    private let searchResultRelay = BehaviorRelay<SearchResultPresentationModel?>(value: nil)
    
    init(presenter: SearchResultPresentable, searchKeyword: String, usecase: TemplatesSearchUsecaseProtocol) {
        self.searchKeyword = searchKeyword
        self.usecase = usecase
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        fetchData()
    }

    override func willResignActive() {
        super.willResignActive()
        
        fetchDataTask?.cancel()
        fetchDataTask = nil
    }
    
    private func fetchData() {
        fetchDataTask?.cancel()
        
        presenter.setLoading(true)
        presenter.showErrorView(false)
        
        fetchDataTask = Task { [weak self] in
            guard let self, !Task.isCancelled else { return }
            
            do {
                let result = try await self.usecase.searchTemplate(keyword: searchKeyword)
                
                let model = SearchResultPresentationModel(resultTrip: result.map { $0.toSearchResultModel() })
                
                self.searchResultRelay.accept(model)
                self.presenter.update(with: model)
                self.presenter.setLoading(false)
            } catch {
                presenter.setLoading(false)
                presenter.showErrorView(true)
            }
        }
    }
}

extension SearchResultInteractor: SearchResultPresentableListener {
    func detachSearchResult() {
        listener?.detachSearchResult()
    }
    
    func searchBtnTapped() {
        
    }
    
    func itemSelected(item: SearchResultItem) {
        switch item {
        case .resultTrip(let trip):
            listener?.popularTravelDidTapFollowDetail(with: trip.id)
        }
    }
    
    func reloadBtnTapped() {
        fetchData()
    }
}
