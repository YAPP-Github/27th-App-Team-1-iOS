//
//  TravelViewController.swift
//  TravelFeature
//
//  Created by kimnahun on 2026-01-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Core
import DSKit
import RIBs
import RxSwift
import SnapKit
import Then
import UIKit

// MARK: - TravelViewController

public final class TravelViewController: UIViewController, TravelPresentable, TravelViewControllable {

    // MARK: - Properties

    weak var listener: TravelPresentableListener?

    private let disposeBag = DisposeBag()

    // MARK: - UI Components

    private let titleLabel = UILabel().then {
        $0.setText(.subTitleLSB, text: "다가오는 여행", color: .NDGL.Text.primary)
    }

    private let menuButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        $0.tintColor = UIColor.NDGL.Icon.primary
    }

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset.bottom = 100
        return collectionView
    }()

    private let emptyStateLabel = UILabel().then {
        $0.setText(.bodyMR, text: "아직 등록된 여행이 없어요", color: .NDGL.Text.tertiary)
        $0.isHidden = true
    }

    private let loadingIndicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }

    // MARK: - Data

    private var trips: [UpcomingTrip] = []

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupCollectionView()
        setupActions()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = UIColor.NDGL.Bg.primary

        [titleLabel, menuButton, collectionView, emptyStateLabel, loadingIndicator].forEach {
            view.addSubview($0)
        }
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(24)
        }

        menuButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().offset(-24)
            $0.size.equalTo(24)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview()
        }

        emptyStateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UpcomingTripCell.self, forCellWithReuseIdentifier: UpcomingTripCell.identifier)
    }

    private func setupActions() {
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func menuButtonTapped() {
        listener?.didTapMenuButton()
    }
}

// MARK: - TravelPresentable

extension TravelViewController {
    func showLoading() {
        loadingIndicator.startAnimating()
    }

    func hideLoading() {
        loadingIndicator.stopAnimating()
    }

    func updateTrips(_ trips: [UpcomingTrip]) {
        self.trips = trips
        emptyStateLabel.isHidden = !trips.isEmpty
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension TravelViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UpcomingTripCell.identifier,
            for: indexPath
        ) as? UpcomingTripCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: trips[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TravelViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let trip = trips[indexPath.item]
        listener?.didTapTrip(trip)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TravelViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 72)
    }
}
