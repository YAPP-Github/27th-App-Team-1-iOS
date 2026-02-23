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

final class FollowDetailViewController: UIViewController, FollowDetailPresentable, FollowDetailViewControllable {

    // MARK: - Properties

    weak var listener: FollowDetailPresentableListener?

    private let disposeBag = DisposeBag()
    private var dayCollectionViewOriginY: CGFloat = .greatestFiniteMagnitude
    private var currentSelectedDay: Int = 1
    private var totalDays: Int = 0
    private var isEditMode: Bool = false
    private var toolbarHeightConstraint: Constraint?

    // MARK: - UI Components (Scroll)
    private let navigationBar = NDGLNavigationBar(
        style: .gray,
        leadingIcon: DSKitAsset.Assets.icChevronLeft3.image
    )
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = DSKitAsset.Colors.white.color
    }
    
    private let contentView = UIView()

    private let mediaInfoView = MediaInfoView()

    private let dayCollectionView = DayCollectionView()

    private let mapView = TravelMapView()

    private let placeListCollectionView = PlaceListCollectionView()

    // 장소 툴바 (내 여행 전용, mapView와 placeListCollectionView 사이)
    private let placeToolbarView = UIView().then {
        $0.isHidden = true
    }

    private let normalToolbarContentView = UIView()

    private let editModeEntryButton = UIButton(type: .system).then {
        $0.setTitle("편집하기", for: .normal)
        $0.tintColor = UIColor(hexCode: "#757575")
    }

    private let editToolbarContentView = UIView().then {
        $0.isHidden = true
    }

    private let selectAllButton = UIButton(type: .system).then {
        $0.setTitle("전체 선택", for: .normal)
        $0.tintColor = UIColor(hexCode: "#757575")
    }

    private let deleteSelectionButton = UIButton(type: .system).then {
        $0.setTitle("선택 삭제", for: .normal)
        $0.tintColor = UIColor(hexCode: "#FF3B30")
    }

    // MARK: - UI Components (Sticky Header)

    private let stickyHeaderView = UIView().then {
        $0.backgroundColor = UIColor(hexCode: "#FFFFFF")
        $0.isHidden = true
    }

    private let stickyDayCollectionView = DayCollectionView()

    // MARK: - UI Components (Fixed)

    private let bottomContainerView = UIView().then {
        $0.backgroundColor = UIColor(hexCode: "#FFFFFF")
        $0.layer.shadowColor = UIColor(hexCode: "#000000").cgColor
        $0.layer.shadowOpacity = 0.06
        $0.layer.shadowOffset = CGSize(width: 0, height: -10)
        $0.layer.shadowRadius = 10
        $0.layer.cornerRadius = 20
    }

    private let addToTripButton = BottomPlacedButton(title: "여행 따라가기")

    // 편집 모드 하단 (내 여행 전용)
    private let editModeBottomView = UIView().then {
        $0.isHidden = true
    }

    private let addPlaceButton = UIButton(type: .system).then {
        $0.setTitle("+", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        $0.tintColor = UIColor(hexCode: "#111111")
        $0.backgroundColor = UIColor(hexCode: "#F5F5F5")
        $0.layer.cornerRadius = 8
    }

    private let editCompleteButton = BottomPlacedButton(title: "편집 완료")

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
        listener?.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParent {
            listener?.detachFollowDetail()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dayCollectionViewOriginY = dayCollectionView.frame.origin.y
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = DSKitAsset.Colors.black50.color

        view.addSubviews(navigationBar, scrollView)
        scrollView.addSubview(contentView)
        [mediaInfoView, dayCollectionView, mapView, placeToolbarView, placeListCollectionView].forEach {
            contentView.addSubview($0)
        }

        // 툴바 내부 구성
        placeToolbarView.addSubview(normalToolbarContentView)
        normalToolbarContentView.addSubview(editModeEntryButton)

        placeToolbarView.addSubview(editToolbarContentView)
        editToolbarContentView.addSubview(selectAllButton)
        editToolbarContentView.addSubview(deleteSelectionButton)

        view.addSubview(stickyHeaderView)
        stickyHeaderView.addSubview(stickyDayCollectionView)

        view.addSubview(bottomContainerView)
        bottomContainerView.addSubview(addToTripButton)
        bottomContainerView.addSubview(editModeBottomView)
        editModeBottomView.addSubview(addPlaceButton)
        editModeBottomView.addSubview(editCompleteButton)
        view.addSubview(loadingIndicator)
    }

    private func setupConstraints() {
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        bottomContainerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(126.adjustedH)
        }
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomContainerView.snp.top)
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

        mapView.snp.makeConstraints {
            $0.top.equalTo(dayCollectionView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(200)
        }

        // 장소 툴바 (내 여행 전용, 기본 height=0)
        placeToolbarView.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            toolbarHeightConstraint = $0.height.equalTo(0).constraint
        }

        normalToolbarContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        editModeEntryButton.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }

        editToolbarContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        selectAllButton.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }

        deleteSelectionButton.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }

        placeListCollectionView.snp.makeConstraints {
            $0.top.equalTo(placeToolbarView.snp.bottom)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-16)
            $0.height.greaterThanOrEqualTo(400)
        }

        // 편집 모드 하단
        editModeBottomView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(52)
        }

        addPlaceButton.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(52)
        }

        editCompleteButton.snp.makeConstraints {
            $0.leading.equalTo(addPlaceButton.snp.trailing).offset(8)
            $0.top.trailing.bottom.equalToSuperview()
        }

        stickyHeaderView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
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
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
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
        editModeEntryButton.addTarget(self, action: #selector(editModeEntryButtonTapped), for: .touchUpInside)
        editCompleteButton.addTarget(self, action: #selector(editCompleteButtonTapped), for: .touchUpInside)
        selectAllButton.addTarget(self, action: #selector(selectAllButtonTapped), for: .touchUpInside)
        deleteSelectionButton.addTarget(self, action: #selector(deleteSelectionButtonTapped), for: .touchUpInside)
        addPlaceButton.addTarget(self, action: #selector(addPlaceButtonTapped), for: .touchUpInside)

        navigationBar.leadingButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Actions

    @objc private func addToTripButtonTapped() {
        listener?.didTapAddToTrip()
    }

    @objc private func addPlaceButtonTapped() {
        listener?.didTapAddPlace()
    }

    @objc private func editModeEntryButtonTapped() {
        toggleEditMode(entering: true)
    }

    @objc private func editCompleteButtonTapped() {
        let orderedPlaces = placeListCollectionView.currentPlaces
        listener?.editCompleted(orderedPlaces: orderedPlaces)
        toggleEditMode(entering: false)
    }

    @objc private func deleteSelectionButtonTapped() {
        let remaining = placeListCollectionView.deleteSelected()
        listener?.didDeletePlaces(remaining: remaining)
    }

    @objc private func selectAllButtonTapped() {
        let allSelected = placeListCollectionView.toggleSelectAll()
        selectAllButton.setTitle(allSelected ? "전체 해제" : "전체 선택", for: .normal)
    }

    private func toggleEditMode(entering: Bool) {
        isEditMode = entering

        if !entering {
            // 편집 완료 시 버튼 타이틀 리셋
            selectAllButton.setTitle("전체 선택", for: .normal)
        }

        UIView.animate(withDuration: 0.2) {
            self.normalToolbarContentView.isHidden = entering
            self.editToolbarContentView.isHidden = !entering
            self.addToTripButton.isHidden = entering
            self.editModeBottomView.isHidden = !entering
        }

        placeListCollectionView.setEditMode(entering)
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

    func configureMode(isMyTravel: Bool) {
        if isMyTravel {
            placeToolbarView.isHidden = false
            toolbarHeightConstraint?.update(offset: 44)
            addToTripButton.configure(title: "일정 추가하기")
        } else {
            placeToolbarView.isHidden = true
            toolbarHeightConstraint?.update(offset: 0)
            addToTripButton.configure(title: "여행 따라가기")
        }
    }

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

        let cellHeight: CGFloat = 129
        let spacing: CGFloat = 13
        let height = CGFloat(places.count) * cellHeight + CGFloat(max(0, places.count - 1)) * spacing
        placeListCollectionView.snp.updateConstraints {
            $0.height.greaterThanOrEqualTo(max(400, height))
        }
    }

    func showToast(_ message: String) {
        Toast.show(type: .success, message: message, bottomPadding: 120)
    }

    func exitEditMode() {
        toggleEditMode(entering: false)
    }

    func showTripCreatedModal(onLater: @escaping () -> Void, onViewTrip: @escaping () -> Void) {
        let modal = NDGLModalViewController(
            title: "여행이 준비됐어요",
            subtitle: "이제 선택한 여행을\n그대로 따라갈 수 있어요.",
            cancelButtonTitle: "나중에 보러가기",
            actionButtonTitle: "여행 보러가기"
        )
        modal.onCancelTapped = onLater
        modal.onActionTapped = onViewTrip
        present(modal, animated: true)
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

        contentView.onChevronTapped = { [weak self, weak bottomSheet] in
            bottomSheet?.dismiss(animated: true) {
                self?.listener?.didTapPlaceDetailChevron(place)
            }
        }

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
