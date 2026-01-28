//
//  FollowDetailViewController.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit
import RIBs
import RxSwift
import SnapKit
import Then

// MARK: - FollowDetailViewController

final class FollowDetailViewController: UIViewController, FollowDetailPresentable, FollowDetailViewControllable {

    // MARK: - Properties

    weak var listener: FollowDetailPresentableListener?

    private let disposeBag = DisposeBag()
    private var dayCollectionViewOriginY: CGFloat = .greatestFiniteMagnitude
    private var currentSelectedDay: Int = 1
    private var totalDays: Int = 0

    // MARK: - UI Components (Scroll)

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

    // MARK: - UI Components (Sticky Header)

    private let stickyHeaderView = UIView().then {
        $0.backgroundColor = UIColor.NDGL.Bg.primary
        $0.isHidden = true
    }

    private let stickyDayCollectionView = DayCollectionView()

    // MARK: - UI Components (Fixed)

    private let addToTripButton = BottomPlacedButton(title: "여행 따라가기")

    private let loadingIndicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupDelegates()
        setupActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            listener?.didTapCloseButton()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dayCollectionViewOriginY = dayCollectionView.frame.origin.y
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = UIColor.NDGL.Bg.primary

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [mediaInfoView, dayCollectionView, budgetView, mapView, placeListCollectionView].forEach {
            contentView.addSubview($0)
        }

        view.addSubview(stickyHeaderView)
        stickyHeaderView.addSubview(stickyDayCollectionView)

        view.addSubview(addToTripButton)
        view.addSubview(loadingIndicator)
    }

    private func setupConstraints() {
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

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

    @objc private func addToTripButtonTapped() {
        listener?.didTapAddToTrip()
    }

    private func syncDaySelection(day: Int) {
        currentSelectedDay = day
        let indexPath = IndexPath(item: day - 1, section: 0)
        dayCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        stickyDayCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
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

        dayCollectionView.applySnapshot(totalDays: detail.days, selectedDay: 1)
        stickyDayCollectionView.applySnapshot(totalDays: detail.days, selectedDay: 1)
    }

    func updatePlaces(_ places: [TravelPlace]) {
        mapView.configure(with: places)
        placeListCollectionView.applySnapshot(places: places)

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

    func showPlaceDetail(_ place: TravelPlace) {
        let contentView = PlaceDetailBottomSheetView()
        contentView.configure(with: place)

        let configuration = BottomSheetConfiguration(
            showDim: true,
            dimColor: UIColor.black.withAlphaComponent(0.7),
            showIndicator: true
        )

        let bottomSheet = BottomSheetViewController(
            contentView: contentView,
            contentHeight: 280,
            configuration: configuration
        )

        present(bottomSheet, animated: false)
    }
}

// MARK: - FollowDetailViewControllable

extension FollowDetailViewController {

    func present(_ viewController: ViewControllable) {
        navigationController?.pushViewController(viewController.uiviewController, animated: true)
    }

    func dismiss(_ viewController: ViewControllable) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension FollowDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let threshold = dayCollectionViewOriginY - 16
        stickyHeaderView.isHidden = offsetY < threshold
    }
}

// MARK: - MediaInfoViewDelegate

extension FollowDetailViewController: MediaInfoViewDelegate {

    func mediaInfoViewDidToggleExpand(_ view: MediaInfoView, isExpanded: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.dayCollectionViewOriginY = self?.dayCollectionView.frame.origin.y ?? 0
        }
    }
}

// MARK: - DayCollectionViewDelegate

extension FollowDetailViewController: DayCollectionViewDelegate {

    func dayCollectionView(_ collectionView: DayCollectionView, didSelectDay day: Int) {
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
