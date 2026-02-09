//
//  PlaceDetailInteractor.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-02-09.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import RIBs

// MARK: - PlaceDetailListener

protocol PlaceDetailListener: AnyObject {
    func placeDetailDidTapBack()
}

// MARK: - PlaceDetailPresentable

protocol PlaceDetailPresentable: Presentable {
    var listener: PlaceDetailPresentableListener? { get set }
}

// MARK: - PlaceDetailPresentableListener

protocol PlaceDetailPresentableListener: AnyObject {
    func didTapBackButton()
}

// MARK: - PlaceDetailInteractor

final class PlaceDetailInteractor: PresentableInteractor<PlaceDetailPresentable>, PlaceDetailInteractable {

    weak var router: PlaceDetailRouting?
    weak var listener: PlaceDetailListener?

    private let googlePlaceId: String

    init(presenter: PlaceDetailPresentable, googlePlaceId: String) {
        self.googlePlaceId = googlePlaceId
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        print("PlaceDetail loaded with googlePlaceId: \(googlePlaceId)")
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - PlaceDetailPresentableListener

extension PlaceDetailInteractor: PlaceDetailPresentableListener {
    func didTapBackButton() {
        listener?.placeDetailDidTapBack()
    }
}
