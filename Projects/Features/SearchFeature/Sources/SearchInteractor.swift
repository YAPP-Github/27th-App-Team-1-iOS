//
//  SearchInteractor.swift
//  SearchFeature
//
//  Created by 최안용 on 2/7/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain

import RIBs
import RxSwift

public protocol SearchRouting: ViewableRouting {
}

protocol SearchPresentable: Presentable {
    var listener: SearchPresentableListener? { get set }

    func update(with model: SearchResultPresentationModel)
    func setLoading(_ isLoading: Bool)
    func showErrorView(_ isError: Bool)
}

public protocol SearchListener: AnyObject {
    func attachFollowDetail(with recommendationId: Int)
    func detachSearch()
}

final class SearchInteractor: PresentableInteractor<SearchPresentable>, SearchInteractable, SearchPresentableListener {
    weak var router: SearchRouting?
    weak var listener: SearchListener?

    private let usecase: TemplatesSearchUsecaseProtocol
    private var fetchDataTask: Task<Void, Never>?
    private var lastKeyword: String?

    init(presenter: SearchPresentable, usecase: TemplatesSearchUsecaseProtocol) {
        self.usecase = usecase
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()

        fetchDataTask?.cancel()
        fetchDataTask = nil
    }

    func search(keyword: String) {
        lastKeyword = keyword
        fetchData(keyword: keyword)
    }

    func itemSelected(item: SearchResultItem) {
        switch item {
        case .resultTrip(let trip):
            listener?.attachFollowDetail(with: trip.id)
        }
    }

    func reloadBtnTapped() {
        guard let keyword = lastKeyword else { return }
        fetchData(keyword: keyword)
    }

    func detachSearch() {
        listener?.detachSearch()
    }

    private func fetchData(keyword: String) {
        fetchDataTask?.cancel()

        presenter.setLoading(true)
        presenter.showErrorView(false)

        fetchDataTask = Task { [weak self] in
            guard let self, !Task.isCancelled else { return }

            do {
                let result = try await self.usecase.searchTemplate(keyword: keyword)

                let model = SearchResultPresentationModel(resultTrip: result.map { $0.toSearchResultModel() })

                self.presenter.update(with: model)
                self.presenter.setLoading(false)
            } catch {
                self.presenter.setLoading(false)
                self.presenter.showErrorView(true)
            }
        }
    }
}
