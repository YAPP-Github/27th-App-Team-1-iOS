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
import UIKit
import RIBs
import RxSwift
import SnapKit
import Then

// MARK: - FollowDetailViewController

public final class FollowDetailViewController: UIViewController, FollowDetailPresentable, FollowDetailViewControllable {

    // MARK: - Properties

    weak var listener: FollowDetailPresentableListener?

    private let disposeBag = DisposeBag()

    // MARK: - UI Components

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

    private let addToTripButton = UIButton(type: .system).then {
        $0.setTitle("내 여행에 담기", for: .normal)
        $0.setTitleColor(UIColor.NDGL.Text.Interactive.inverse, for: .normal)
        $0.titleLabel?.font = DSKitFontFamily.Pretendard.semiBold.font(size: 16)
        $0.backgroundColor = UIColor.NDGL.Bg.Interactive.primary
        $0.layer.cornerRadius = 12
    }

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

    // MARK: - Setup


    private func setupUI() {
        view.backgroundColor = UIColor.NDGL.Bg.primary

        [scrollView, addToTripButton, loadingIndicator].forEach {
            view.addSubview($0)
        }

        scrollView.addSubview(contentView)

        [mediaInfoView, dayCollectionView, budgetView, mapView, placeListCollectionView].forEach {
            contentView.addSubview($0)
        }
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
            $0.height.equalTo(120)
        }

        dayCollectionView.snp.makeConstraints {
            $0.top.equalTo(mediaInfoView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(40)
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

        addToTripButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(52)
        }
    }

    private func setupDelegates() {
        mediaInfoView.delegate = self
        dayCollectionView.dayDelegate = self
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

    private func updateMediaInfoViewHeight(_ height: CGFloat) {
        mediaInfoView.snp.updateConstraints {
            $0.height.equalTo(height)
        }

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
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
        dayCollectionView.applySnapshot(totalDays: detail.days, selectedDay: 1)
    }

    func updatePlaces(_ places: [TravelPlace]) {
        mapView.configure(with: places)
        placeListCollectionView.applySnapshot(places: places)

        // PlaceList 높이 동적 업데이트
        let height = CGFloat(places.count * 140)
        placeListCollectionView.snp.updateConstraints {
            $0.height.greaterThanOrEqualTo(max(400, height))
        }
    }

    func updateBudget(_ budget: Int) {
        budgetView.configure(budget: budget)
    }
}

// MARK: - MediaInfoViewDelegate

extension FollowDetailViewController: MediaInfoViewDelegate {
    func mediaInfoViewDidToggleExpand(_ view: MediaInfoView, isExpanded: Bool) {
        let newHeight = isExpanded ? view.getExpandedHeight() : view.getCollapsedHeight()
        updateMediaInfoViewHeight(newHeight)
    }
}

// MARK: - DayCollectionViewDelegate

extension FollowDetailViewController: DayCollectionViewDelegate {
    func dayCollectionView(_ collectionView: DayCollectionView, didSelectDay day: Int) {
        listener?.didSelectDay(day)
    }
}

// MARK: - PlaceListCollectionViewDelegate

extension FollowDetailViewController: PlaceListCollectionViewDelegate {
    func placeListCollectionView(_ collectionView: PlaceListCollectionView, didSelectPlace place: TravelPlace) {
        listener?.didSelectPlace(place)
    }
}
