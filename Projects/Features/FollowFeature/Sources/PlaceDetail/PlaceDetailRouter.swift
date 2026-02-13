//
//  PlaceDetailRouter.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-02-09.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

// MARK: - PlaceDetailInteractable

protocol PlaceDetailInteractable: Interactable {
    var router: PlaceDetailRouting? { get set }
    var listener: PlaceDetailListener? { get set }
}

// MARK: - PlaceDetailViewControllable

protocol PlaceDetailViewControllable: ViewControllable { }

// MARK: - PlaceDetailRouting

protocol PlaceDetailRouting: ViewableRouting { }

// MARK: - PlaceDetailRouter

final class PlaceDetailRouter: ViewableRouter<PlaceDetailInteractable, PlaceDetailViewControllable>, PlaceDetailRouting {

    override init(
        interactor: PlaceDetailInteractable,
        viewController: PlaceDetailViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
