//
//  AddPlaceRouter.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-02-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

// MARK: - AddPlaceInteractable

protocol AddPlaceInteractable: Interactable {
    var router: AddPlaceRouting? { get set }
    var listener: AddPlaceListener? { get set }
}

// MARK: - AddPlaceViewControllable

protocol AddPlaceViewControllable: ViewControllable { }

// MARK: - AddPlaceRouting

protocol AddPlaceRouting: ViewableRouting { }

// MARK: - AddPlaceRouter

final class AddPlaceRouter: ViewableRouter<AddPlaceInteractable, AddPlaceViewControllable>, AddPlaceRouting {

    override init(interactor: AddPlaceInteractable, viewController: AddPlaceViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
