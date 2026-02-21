//
//  SearchRouter.swift
//  SearchFeature
//
//  Created by 최안용 on 2/7/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

protocol SearchInteractable: Interactable, SearchResultListener {
    var router: SearchRouting? { get set }
    var listener: SearchListener? { get set }
}

protocol SearchViewControllable: ViewControllable {
    func pushChild(_ viewControllable: ViewControllable)
    func popChild(_ animated: Bool)
}

final class SearchRouter: ViewableRouter<SearchInteractable, SearchViewControllable>, SearchRouting {
    private let searchResultBuilder: SearchResultBuildable
    private var searchResultRouter: SearchResultRouting?
    
    init(
        interactor: SearchInteractable,
        viewController: SearchViewControllable,
        searchResultBuilder: SearchResultBuildable
    ) {
        self.searchResultBuilder = searchResultBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSearchResult(keyword: String) {
        guard searchResultRouter == nil else { return }
        
        let router = searchResultBuilder.build(
            withListener: interactor,
            searchKeyword: keyword
        )
        self.searchResultRouter = router
        attachChild(router)
        viewController.pushChild(router.viewControllable)
    }
    
    func detachSearchResult() {
        guard let routing = searchResultRouter else { return }
        detachChild(routing)
        self.searchResultRouter = nil
    }
}
