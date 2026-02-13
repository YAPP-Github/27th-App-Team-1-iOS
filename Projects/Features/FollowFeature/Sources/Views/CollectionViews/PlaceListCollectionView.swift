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
        layout.minimumLineSpacing = 13

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
            guard let self = self,
                  let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PlaceCell.identifier,
                for: indexPath
            ) as? PlaceCell else {
                return UICollectionViewCell()
            }

            let isLast = indexPath.item == (self.places.count) - 1
            cell.configure(with: place, isLast: isLast)
            cell.onContainerTapped = { [weak self] in
                guard let self = self else { return }
                self.placeDelegate?.placeListCollectionView(self, didSelectPlace: place)
            }
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

extension PlaceListCollectionView: UICollectionViewDelegate { }

// MARK: - UICollectionViewDelegateFlowLayout

extension PlaceListCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 129)
    }
}
