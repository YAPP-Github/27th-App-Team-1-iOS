//
//  PlaceListCollectionView.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import UIKit

protocol PlaceListCollectionViewDelegate: AnyObject {
    func placeListCollectionView(_ collectionView: PlaceListCollectionView, didSelectPlace place: TravelPlace)
}

final class PlaceListCollectionView: UICollectionView {

    // MARK: - Properties

    weak var placeDelegate: PlaceListCollectionViewDelegate?
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, TravelPlace>?
    private var places: [TravelPlace] = []

    // MARK: - Initialization

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        super.init(frame: .zero, collectionViewLayout: layout)
        setupCollectionView()
        setupDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupCollectionView() {
        backgroundColor = .clear
        isScrollEnabled = false
        delegate = self
        register(PlaceCell.self, forCellWithReuseIdentifier: PlaceCell.identifier)
    }

    private func setupDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<Int, TravelPlace>(
            collectionView: self
        ) { [weak self] collectionView, indexPath, place in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PlaceCell.identifier,
                for: indexPath
            ) as? PlaceCell else {
                return UICollectionViewCell()
            }

            let isLast = indexPath.item == (self?.places.count ?? 0) - 1
            cell.configure(with: place, isLast: isLast)
            return cell
        }
    }

    // MARK: - Public Methods

    func applySnapshot(places: [TravelPlace]) {
        self.places = places

        var snapshot = NSDiffableDataSourceSnapshot<Int, TravelPlace>()
        snapshot.appendSections([0])
        snapshot.appendItems(places, toSection: 0)

        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate

extension PlaceListCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < places.count else { return }
        let place = places[indexPath.item]
        placeDelegate?.placeListCollectionView(self, didSelectPlace: place)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PlaceListCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 140)
    }
}
