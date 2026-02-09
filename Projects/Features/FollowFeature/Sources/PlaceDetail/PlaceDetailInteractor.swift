//
//  PlaceDetailInteractor.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-02-09.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
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

    private let followService: FollowServiceProtocol
    private let googlePlaceId: String

    // MARK: - State

    private var placeDetail: PlaceDetail?
    private var placePhotos: [PlacePhoto] = []

    init(
        presenter: PlaceDetailPresentable,
        followService: FollowServiceProtocol,
        googlePlaceId: String
    ) {
        self.followService = followService
        self.googlePlaceId = googlePlaceId
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        fetchPlaceData()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    private func fetchPlaceData() {
        Task {
            async let detailResult = followService.fetchPlaceDetail(googlePlaceId: googlePlaceId)
            async let photosResult = followService.fetchPlacePhotos(googlePlaceId: googlePlaceId)

            let (detail, photos) = await (detailResult, photosResult)

            await MainActor.run {
                switch detail {
                case .success(let placeDetail):
                    self.placeDetail = placeDetail
                case .failure(let error):
                    switch error {
                    case .missingParameter(let message):
                        print("PlaceDetail 실패 [missingParameter]: \(message)")
                    case .notFound(let message):
                        print("PlaceDetail 실패 [notFound]: \(message)")
                    case .unknown(let code, let message):
                        print("PlaceDetail 실패 [unknown] code: \(code), message: \(message)")
                    }
                }

                switch photos {
                case .success(let placePhotos):
                    self.placePhotos = placePhotos
                case .failure(let error):
                    switch error {
                    case .missingParameter(let message):
                        print("PlacePhotos 실패 [missingParameter]: \(message)")
                    case .serverError(let message):
                        print("PlacePhotos 실패 [serverError]: \(message)")
                    case .googleApiError(let message):
                        print("PlacePhotos 실패 [googleApiError]: \(message)")
                    case .unknown(let code, let message):
                        print("PlacePhotos 실패 [unknown] code: \(code), message: \(message)")
                    }
                }
            }
        }
    }
}

// MARK: - PlaceDetailPresentableListener

extension PlaceDetailInteractor: PlaceDetailPresentableListener {
    func didTapBackButton() {
        listener?.placeDetailDidTapBack()
    }
}
