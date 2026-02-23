//
//  MyTravelInteractor.swift
//  MyTravelFeature
//
//  Created by 최안용 on 2/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

import Domain

import RIBs
import RxCocoa
import RxRelay
import RxSwift

public protocol MyTravelRouting: ViewableRouting {
    
}

protocol MyTravelPresentable: Presentable {
    var listener: MyTravelPresentableListener? { get set }
    
    func update(with sections: [(MyTravelSectionKind, [MyTravelItem])])
    func setLoading(_ isLoading: Bool)
    func showErrorView(_ isError: Bool)
}

public protocol MyTravelListener: AnyObject {
    func myTraveDidTapFollowDetail(with recommendationId: Int)
    func myTraveDidTapSearch()
    func myTraveDidTapPopularTravel()
}

final class MyTravelInteractor: PresentableInteractor<MyTravelPresentable>, MyTravelInteractable {
    weak var router: MyTravelRouting?
    weak var listener: MyTravelListener?
    
    private var fetchDataTask: Task<Void, Never>?
    private let myTravelRelay = BehaviorRelay<[(MyTravelSectionKind, [MyTravelItem])]>(value: [])
    private let usecase: MyTravelUsecaseProtocol
    private let disposeBag = DisposeBag()
    
    init(presenter: MyTravelPresentable, usecase: MyTravelUsecaseProtocol) {
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
    
    private func fetchMyTravelData() {
        fetchDataTask?.cancel()
        
        presenter.setLoading(true)
        presenter.showErrorView(false)
        
        fetchDataTask = Task { [weak self] in
            guard let self, !Task.isCancelled else { return }
            
            var myTripBanner: MyTravelPresentationModel.Banner?
            var upcomingList: [MyTravelPresentationModel.Upcoming] = []
            var sections: [(MyTravelSectionKind, [MyTravelItem])] = []
            
            do {
                do {
                    myTripBanner = try await usecase.fetchMyTripInfo().toMyTravelModel()
                } catch {
                    print("Log: MyTripInfo 로드 실패 - \(error)")
                    myTripBanner = nil
                }
                
                upcomingList = try await usecase.fetchUpcomingList().map { $0.toMyTravelModel() }
                
                var recommendItems: [MyTravelPresentationModel.RecommendedTrip] = []
                if myTripBanner == nil && upcomingList.isEmpty {
                    recommendItems = try await usecase.fetchRecommendTripList().map { $0.toRecommendMyTravelModel() }
                }
                
                if let banner = myTripBanner {
                    sections.append((.banner, [.banner(banner)]))
                }
                
                if upcomingList.isEmpty {
                    sections.append((.upcomingTrips(isEmpty: true), [.banner(.empty)]))
                } else {
                    sections.append(
                        (.upcomingTrips(isEmpty: false),
                         upcomingList.map { MyTravelItem.upcomingList($0) })
                    )
                }
                
                if !recommendItems.isEmpty {
                    sections.append((.recommendedTrip, recommendItems.map { MyTravelItem.recommendTrip($0) }))
                }
                
                await MainActor.run { [sections] in
                    self.presenter.setLoading(false)
                    self.presenter.update(with: sections)
                }
                    
            } catch {
                await MainActor.run {
                    self.presenter.setLoading(false)
                    self.presenter.showErrorView(true)
                }
            }
        }
    }
}

extension MyTravelInteractor: MyTravelPresentableListener {
    func myTraveDidTapPopularTravel() {
        listener?.myTraveDidTapPopularTravel()
    }
    
    func viewWillAppear() {
        fetchMyTravelData()
    }
    
    func myTraveDidTapSearch() {
        listener?.myTraveDidTapSearch()
    }
    
    func itemSelected(item: MyTravelItem) {
        switch item {
        case .recommendTrip(let trip):
            listener?.myTraveDidTapFollowDetail(with: trip.id)
        case .upcomingList(let upcoming):
            listener?.myTraveDidTapFollowDetail(with: upcoming.id)
        case .banner(let myTrip):
            listener?.myTraveDidTapFollowDetail(with: myTrip.id)
        }
    }
    
    func reloadBtnTapped() {
        fetchMyTravelData()
    }
}
