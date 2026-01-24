//
//  FollowDetailViewController.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Core
import Domain
import DSKit
import RIBs
import RxSwift
import SnapKit
import Then
import UIKit

// MARK: - FollowDetailViewController

public final class FollowDetailViewController: UIViewController, FollowDetailPresentable, FollowDetailViewControllable {

    // MARK: - Properties

    weak var listener: FollowDetailPresentableListener?

    private let disposeBag = DisposeBag()
    private var dayCollectionViewOriginY: CGFloat = CGFloat.greatestFiniteMagnitude
    private var currentSelectedDay: Int = 1
    private var totalDays: Int = 0

    // MARK: - UI Components (스크롤 영역)

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
        $0.contentInset.bottom = 100
    }

    private let contentView = UIView()

    private let mediaInfoView = MediaInfoView()

    private let dayCollectionView = DayCollectionView()

    private let budgetView = BudgetView()

    private let mapView = TravelMapView()

    private let placeListCollectionView = PlaceListCollectionView()

    // MARK: - UI Components (스티키 헤더)

    private let stickyHeaderView = UIView().then {
        $0.backgroundColor = UIColor.NDGL.Bg.primary
        $0.isHidden = true
    }

    private let stickyDayCollectionView = DayCollectionView()

    // MARK: - UI Components (고정 버튼/로딩)

    private let addToTripButton = BottomPlacedButton(title: "여행 따라가기")
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }

    // MARK: - Initialization

    public init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupDelegates()
        setupActions()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 네비게이션 백버튼으로 돌아갈 때 RIB detach 처리
        if isMovingFromParent {
            listener?.didTapCloseButton()
        }
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // dayCollectionView의 scrollView 내 위치 계산
        dayCollectionViewOriginY = dayCollectionView.frame.origin.y
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = UIColor.NDGL.Bg.primary

        // 스크롤 영역
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [mediaInfoView, dayCollectionView, budgetView, mapView, placeListCollectionView].forEach {
            contentView.addSubview($0)
        }

        // 스티키 헤더 (scrollView 위에 배치)
        view.addSubview(stickyHeaderView)
        stickyHeaderView.addSubview(stickyDayCollectionView)

        // 버튼 및 로딩
        view.addSubview(addToTripButton)
        view.addSubview(loadingIndicator)
    }

    private func setupConstraints() {
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        // 스크롤 영역
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        mediaInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        dayCollectionView.snp.makeConstraints {
            $0.top.equalTo(mediaInfoView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(30)
        }

        budgetView.snp.makeConstraints {
            $0.top.equalTo(dayCollectionView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(44)
        }

        mapView.snp.makeConstraints {
            $0.top.equalTo(budgetView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(200)
        }

        placeListCollectionView.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.height.greaterThanOrEqualTo(400)
        }

        // 스티키 헤더
        stickyHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(62)
        }

        stickyDayCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(30)
        }

        addToTripButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(52)
        }
    }

    private func setupDelegates() {
        scrollView.delegate = self
        mediaInfoView.delegate = self
        dayCollectionView.dayDelegate = self
        stickyDayCollectionView.dayDelegate = self
        placeListCollectionView.placeDelegate = self
    }

    private func setupActions() {
        addToTripButton.addTarget(self, action: #selector(addToTripButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func backButtonTapped() {
        listener?.didTapCloseButton()
    }

    @objc private func addToTripButtonTapped() {
        listener?.didTapAddToTrip()
    }

    // MARK: - Private Methods

    private func syncDaySelection(day: Int) {
        currentSelectedDay = day
        let indexPath = IndexPath(item: day - 1, section: 0)
        dayCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        stickyDayCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
}

// MARK: - UIScrollViewDelegate

extension FollowDetailViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y

        // dayCollectionView가 화면 상단에 도달하면 스티키 헤더 표시
        let threshold = dayCollectionViewOriginY - 16
        stickyHeaderView.isHidden = offsetY < threshold
    }
}

// MARK: - FollowDetailPresentable

extension FollowDetailViewController {
    func showLoading() {
        loadingIndicator.startAnimating()
    }

    func hideLoading() {
        loadingIndicator.stopAnimating()
    }

    func updateTravelDetail(_ detail: TravelDetail) {
        mediaInfoView.configure(with: detail)
        totalDays = detail.days

        // 두 컬렉션뷰 모두 업데이트
        dayCollectionView.applySnapshot(totalDays: detail.days, selectedDay: 1)
        stickyDayCollectionView.applySnapshot(totalDays: detail.days, selectedDay: 1)
    }

    func updatePlaces(_ places: [TravelPlace]) {
        mapView.configure(with: places)
        placeListCollectionView.applySnapshot(places: places)

        // PlaceList 높이 동적 업데이트 (셀 높이 135 + spacing 8)
        let cellHeight: CGFloat = 135
        let spacing: CGFloat = 8
        let height = CGFloat(places.count) * cellHeight + CGFloat(max(0, places.count - 1)) * spacing
        placeListCollectionView.snp.updateConstraints {
            $0.height.greaterThanOrEqualTo(max(400, height))
        }
    }

    func updateBudget(_ budget: Int) {
        budgetView.configure(budget: budget)
    }
}

// MARK: - FollowDetailViewControllable

extension FollowDetailViewController {
    public func present(_ viewController: ViewControllable) {
        navigationController?.pushViewController(viewController.uiviewController, animated: true)
    }

    public func dismiss(_ viewController: ViewControllable) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - MediaInfoViewDelegate

extension FollowDetailViewController: MediaInfoViewDelegate {
    func mediaInfoViewDidToggleExpand(_ view: MediaInfoView, isExpanded: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            // 레이아웃 변경 후 dayCollectionView 위치 재계산
            self?.dayCollectionViewOriginY = self?.dayCollectionView.frame.origin.y ?? 0
        }
    }
}

// MARK: - DayCollectionViewDelegate

extension FollowDetailViewController: DayCollectionViewDelegate {
    func dayCollectionView(_ collectionView: DayCollectionView, didSelectDay day: Int) {
        // 두 컬렉션뷰 선택 상태 동기화
        syncDaySelection(day: day)
        listener?.didSelectDay(day)
    }
}

// MARK: - PlaceListCollectionViewDelegate

extension FollowDetailViewController: PlaceListCollectionViewDelegate {
    func placeListCollectionView(_ collectionView: PlaceListCollectionView, didSelectPlace place: TravelPlace) {
        listener?.didSelectPlace(place)
    }
}
