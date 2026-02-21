//
//  SearchResultRouter.swift
//  SearchFeature
//
//  Created by 최안용 on 2/18/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

protocol SearchResultInteractable: Interactable {
    var router: SearchResultRouting? { get set }
    var listener: SearchResultListener? { get set }
}

protocol SearchResultViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchResultRouter: ViewableRouter<SearchResultInteractable, SearchResultViewControllable>, SearchResultRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SearchResultInteractable, viewController: SearchResultViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
