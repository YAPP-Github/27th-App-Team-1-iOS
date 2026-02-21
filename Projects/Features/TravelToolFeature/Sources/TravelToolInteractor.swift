//
//  TravelToolInteractor.swift
//  TravelToolFeature
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import RIBs
import RxSwift

// MARK: - TravelToolListener

public protocol TravelToolListener: AnyObject {
}

// MARK: - TravelToolPresentable

protocol TravelToolPresentable: Presentable {
    var listener: TravelToolPresentableListener? { get set }
}

// MARK: - TravelToolPresentableListener

protocol TravelToolPresentableListener: AnyObject {
}

// MARK: - TravelToolInteractor

final class TravelToolInteractor: PresentableInteractor<TravelToolPresentable>, TravelToolInteractable {

    weak var router: TravelToolRouting?
    weak var listener: TravelToolListener?

    private let disposeBag = DisposeBag()

    override init(presenter: TravelToolPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - TravelToolPresentableListener

extension TravelToolInteractor: TravelToolPresentableListener {
}
