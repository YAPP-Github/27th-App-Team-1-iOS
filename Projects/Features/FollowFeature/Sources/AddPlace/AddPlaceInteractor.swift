//
//  AddPlaceInteractor.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-02-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain

import RIBs
import RxSwift

// MARK: - AddPlacePresentable

protocol AddPlacePresentable: Presentable {
    var listener: AddPlacePresentableListener? { get set }

    func showResult(_ result: PlaceSearchResult)
    func showNoResults()
    func setLoading(_ isLoading: Bool)
    func setAddButtonEnabled(_ enabled: Bool)
}

// MARK: - AddPlaceListener

public protocol AddPlaceListener: AnyObject {
    func addPlaceDidCancel()
    func addPlaceDidComplete(with place: PlaceSearchResult)
}

// MARK: - AddPlacePresentableListener

protocol AddPlacePresentableListener: AnyObject {
    func didTapBack()
    func search(keyword: String)
    func didTapAddButton()
}

// MARK: - AddPlaceInteractor

final class AddPlaceInteractor: PresentableInteractor<AddPlacePresentable>, AddPlaceInteractable {

    weak var router: AddPlaceRouting?
    weak var listener: AddPlaceListener?

    private let followDetailUsecase: FollowDetailUsecaseProtocol
    private var selectedPlace: PlaceSearchResult?
    private var searchTask: Task<Void, Never>?

    init(presenter: AddPlacePresentable, followDetailUsecase: FollowDetailUsecaseProtocol) {
        self.followDetailUsecase = followDetailUsecase
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func willResignActive() {
        super.willResignActive()
        searchTask?.cancel()
        searchTask = nil
    }

    // MARK: - Private

    private func performSearch(keyword: String) {
        searchTask?.cancel()

        presenter.setLoading(true)

        searchTask = Task { [weak self] in
            guard let self, !Task.isCancelled else { return }

            do {
                let results = try await followDetailUsecase.searchPlaces(keyword: keyword)

                await MainActor.run { [weak self] in
                    guard let self, !Task.isCancelled else { return }
                    self.presenter.setLoading(false)

                    if let first = results.first {
                        self.selectedPlace = first
                        self.presenter.showResult(first)
                        self.presenter.setAddButtonEnabled(true)
                    } else {
                        self.selectedPlace = nil
                        self.presenter.showNoResults()
                        self.presenter.setAddButtonEnabled(false)
                    }
                }
            } catch {
                await MainActor.run { [weak self] in
                    self?.presenter.setLoading(false)
                    self?.presenter.showNoResults()
                    self?.presenter.setAddButtonEnabled(false)
                }
            }
        }
    }
}

// MARK: - AddPlacePresentableListener

extension AddPlaceInteractor: AddPlacePresentableListener {

    func didTapBack() {
        listener?.addPlaceDidCancel()
    }

    func search(keyword: String) {
        performSearch(keyword: keyword)
    }

    func didTapAddButton() {
        guard let place = selectedPlace else { return }
        listener?.addPlaceDidComplete(with: place)
    }
}
