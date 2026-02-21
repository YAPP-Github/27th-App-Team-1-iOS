//
//  TravelToolRouter.swift
//  TravelToolFeature
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

// MARK: - TravelToolInteractable

protocol TravelToolInteractable: Interactable {
    var router: TravelToolRouting? { get set }
    var listener: TravelToolListener? { get set }
}

// MARK: - TravelToolViewControllable

public protocol TravelToolViewControllable: ViewControllable {
}

// MARK: - TravelToolRouting

public protocol TravelToolRouting: ViewableRouting {
}

// MARK: - TravelToolRouter

final class TravelToolRouter: ViewableRouter<TravelToolInteractable, TravelToolViewControllable>, TravelToolRouting {

    override init(
        interactor: TravelToolInteractable,
        viewController: TravelToolViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
