//
//  SearchInteractor.swift
//  SearchFeature
//
//  Created by 최안용 on 2/7/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain

import RIBs
import RxSwift

public protocol SearchRouting: ViewableRouting {
    func attachSearchResult(keyword: String)
    func detachSearchResult()
}

protocol SearchPresentable: Presentable {
    var listener: SearchPresentableListener? { get set }
}

public protocol SearchListener: AnyObject {
    func attachFollowDetail(with recommendationId: Int)
    func detachSearch()
}

final class SearchInteractor: PresentableInteractor<SearchPresentable>, SearchInteractable, SearchPresentableListener {
    weak var router: SearchRouting?
    weak var listener: SearchListener?

    private let usecase: TemplatesSearchUsecaseProtocol
    
    init(presenter: SearchPresentable, usecase: TemplatesSearchUsecaseProtocol) {
        self.usecase = usecase
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func search(keyword: String) {
        router?.attachSearchResult(keyword: keyword)
    }
    
    func detachSearchResult() {
        router?.detachSearchResult()
    }
    
    func popularTravelDidTapFollowDetail(with recommendationId: Int) {
        listener?.attachFollowDetail(with: recommendationId)
    }
    
    func detachSearch() {
        listener?.detachSearch()
    }
}
