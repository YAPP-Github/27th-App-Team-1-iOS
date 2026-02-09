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

    func updatePlaceInfo(viewModel: PlaceDetailViewModel)
}

// MARK: - PlaceDetailPresentableListener

protocol PlaceDetailPresentableListener: AnyObject {
    func didTapBackButton()
    func didScrollToTipPage(_ page: Int)
}

// MARK: - PlaceDetailViewModel

struct PlaceDetailViewModel {
    let name: String
    let rating: Double?
    let reviewCount: Int?
    let thumbnailURL: String?
    let address: String?
    let phoneNumber: String?
    let estimatedDuration: Int?
    let youtubeTips: [String]
    let youtuberName: String
    let planBItems: [PlanBInfo]
    let placePhotos: [PlacePhoto]
}

// MARK: - PlaceDetailInteractor

final class PlaceDetailInteractor: PresentableInteractor<PlaceDetailPresentable>, PlaceDetailInteractable {

    weak var router: PlaceDetailRouting?
    weak var listener: PlaceDetailListener?

    private let followService: FollowServiceProtocol
    private let travelPlace: TravelPlace
    private let youtuberName: String

    // MARK: - State

    private var placeDetail: PlaceDetail?
    private var placePhotos: [PlacePhoto] = []
    private var currentTipPage: Int = 0

    init(
        presenter: PlaceDetailPresentable,
        followService: FollowServiceProtocol,
        travelPlace: TravelPlace,
        youtuberName: String
    ) {
        self.followService = followService
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

            async let detailResult = self.followService.fetchPlaceDetail(googlePlaceId: googlePlaceId)
            async let photosResult = self.followService.fetchPlacePhotos(googlePlaceId: googlePlaceId)

            let (detail, photos) = await (detailResult, photosResult)

            await MainActor.run { [weak self] in
                guard let self else { return }
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

                updatePresenter()
            }
        }
    }

    private func updatePresenter() {
        let viewModel = PlaceDetailViewModel(
            name: placeDetail?.name ?? travelPlace.place.name,
            rating: placeDetail?.rating,
            reviewCount: placeDetail?.userRatingCount,
            thumbnailURL: placeDetail?.thumbnail ?? travelPlace.place.thumbnail,
            address: placeDetail?.formattedAddress,
            phoneNumber: placeDetail?.internationalPhoneNumber ?? placeDetail?.nationalPhoneNumber,
            estimatedDuration: travelPlace.estimatedDuration,
            youtubeTips: travelPlace.youtubeTips,
            youtuberName: youtuberName,
            planBItems: travelPlace.planB,
            placePhotos: placePhotos
        )
        presenter.updatePlaceInfo(viewModel: viewModel)
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
