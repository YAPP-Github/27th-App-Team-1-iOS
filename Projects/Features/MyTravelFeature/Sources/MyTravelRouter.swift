//
//  MyTravelRouter.swift
//  MyTravelFeature
//
//  Created by 최안용 on 2/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

protocol MyTravelInteractable: Interactable {
    var router: MyTravelRouting? { get set }
    var listener: MyTravelListener? { get set }
}

protocol MyTravelViewControllable: ViewControllable {
    
}

final class MyTravelRouter: ViewableRouter<MyTravelInteractable, MyTravelViewControllable>, MyTravelRouting {

    override init(
        interactor: MyTravelInteractable,
        viewController: MyTravelViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
