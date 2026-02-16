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

    func updatePlaceDetail(_ detail: PlaceDetail?, travelPlace: TravelPlace, youtuberName: String)
    func updatePhotos(_ photos: [PlacePhoto])
}

// MARK: - PlaceDetailPresentableListener

protocol PlaceDetailPresentableListener: AnyObject {
    func didTapBackButton()
    func didScrollToTipPage(_ page: Int)
}

// MARK: - PlaceDetailInteractor

final class PlaceDetailInteractor: PresentableInteractor<PlaceDetailPresentable>, PlaceDetailInteractable {

    weak var router: PlaceDetailRouting?
    weak var listener: PlaceDetailListener?

    private let followDetailUsecase: FollowDetailUsecaseProtocol
    private let travelPlace: TravelPlace
    private let youtuberName: String

    // MARK: - State

    private var placeDetail: PlaceDetail?
    private var placePhotos: [PlacePhoto] = []
    private var currentTipPage: Int = 0

    init(
        presenter: PlaceDetailPresentable,
        followDetailUsecase: FollowDetailUsecaseProtocol,
        travelPlace: TravelPlace,
        youtuberName: String
    ) {
        self.followDetailUsecase = followDetailUsecase
        self.travelPlace = travelPlace
        self.youtuberName = youtuberName
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
        let googlePlaceId = travelPlace.place.googlePlaceId

        Task { [weak self] in
            guard let self else { return }

            do {
                async let detailResult = self.followDetailUsecase.fetchPlaceDetail(googlePlaceId: googlePlaceId)
                async let photosResult = self.followDetailUsecase.fetchPlacePhotos(googlePlaceId: googlePlaceId)
                
                let (detail, photos) = try await (detailResult, photosResult)
                
                await MainActor.run {
                    self.placeDetail = detail
                    self.placePhotos = photos
                    self.updatePresenter()
                }
            } catch {
                print(error)
            }
        }
    }

    private func updatePresenter() {
        presenter.updatePlaceDetail(placeDetail, travelPlace: travelPlace, youtuberName: youtuberName)
        presenter.updatePhotos(placePhotos)
    }
}

// MARK: - PlaceDetailPresentableListener

extension PlaceDetailInteractor: PlaceDetailPresentableListener {
    func didTapBackButton() {
        listener?.placeDetailDidTapBack()
    }

    func didScrollToTipPage(_ page: Int) {
        currentTipPage = page
    }
}
