//
//  YoutuberContentCollectionView.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-22.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import UIKit

protocol YoutuberContentCollectionViewDelegate: AnyObject {
    func youtuberContentCollectionView(_ collectionView: YoutuberContentCollectionView, didSelectItemAt index: Int)
}

final class YoutuberContentCollectionView: UICollectionView {

    // MARK: - Properties

    weak var contentDelegate: YoutuberContentCollectionViewDelegate?

    private let maxItemCount = 3
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, PopularTrip>?

    // MARK: - Initialization

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12

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
        register(YoutuberContentCell.self, forCellWithReuseIdentifier: YoutuberContentCell.identifier)
    }

    private func setupDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<Int, PopularTrip>(
            collectionView: self
        ) { collectionView, indexPath, trip in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: YoutuberContentCell.identifier,
                for: indexPath
            ) as? YoutuberContentCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: trip)
            return cell
        }
    }

    // MARK: - Public Methods

    func applySnapshot(trips: [PopularTrip]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, PopularTrip>()
        snapshot.appendSections([0])
        snapshot.appendItems(Array(trips.prefix(maxItemCount)))
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate

extension YoutuberContentCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        contentDelegate?.youtuberContentCollectionView(self, didSelectItemAt: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension YoutuberContentCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 88)
    }
}
