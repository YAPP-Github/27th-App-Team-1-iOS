//
//  SettingRouter.swift
//  SettingFeature
//
//  Created by 최안용 on 2/9/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

protocol SettingInteractable: Interactable {
    var router: SettingRouting? { get set }
    var listener: SettingListener? { get set }
}

protocol SettingViewControllable: ViewControllable {
    
}

final class SettingRouter: ViewableRouter<SettingInteractable, SettingViewControllable>, SettingRouting {

    override init(interactor: SettingInteractable, viewController: SettingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
