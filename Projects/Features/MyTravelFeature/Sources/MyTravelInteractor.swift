//
//  MyTravelInteractor.swift
//  MyTravelFeature
//
//  Created by 최안용 on 2/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs
import RxSwift

protocol MyTravelRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MyTravelPresentable: Presentable {
    var listener: MyTravelPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MyTravelListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MyTravelInteractor: PresentableInteractor<MyTravelPresentable>, MyTravelInteractable, MyTravelPresentableListener {

    weak var router: MyTravelRouting?
    weak var listener: MyTravelListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: MyTravelPresentable) {
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
}
