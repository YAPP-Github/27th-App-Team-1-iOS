//
//  PopularTravelRouter.swift
//  PopularTravelFeature
//
//  Created by 최안용 on 2/12/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

protocol PopularTravelInteractable: Interactable {
    var router: PopularTravelRouting? { get set }
    var listener: PopularTravelListener? { get set }
}

protocol PopularTravelViewControllable: ViewControllable {
    
}

final class PopularTravelRouter: ViewableRouter<PopularTravelInteractable, PopularTravelViewControllable>, PopularTravelRouting {

    override init(interactor: PopularTravelInteractable, viewController: PopularTravelViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
