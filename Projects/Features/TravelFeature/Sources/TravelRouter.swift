//
//  TravelRouter.swift
//  TravelFeature
//
//  Created by kimnahun on 2026-01-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

// MARK: - TravelInteractable

protocol TravelInteractable: Interactable {
    var router: TravelRouting? { get set }
    var listener: TravelListener? { get set }
}

// MARK: - TravelViewControllable

public protocol TravelViewControllable: ViewControllable {
}

// MARK: - TravelRouting

public protocol TravelRouting: ViewableRouting {
}

// MARK: - TravelRouter

final class TravelRouter: ViewableRouter<TravelInteractable, TravelViewControllable>, TravelRouting {

    override init(
        interactor: TravelInteractable,
        viewController: TravelViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
