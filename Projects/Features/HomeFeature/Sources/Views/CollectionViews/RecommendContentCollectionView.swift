//
//  RecommendContentCollectionView.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-22.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import UIKit

protocol RecommendContentCollectionViewDelegate: AnyObject {
    func recommendContentCollectionView(_ collectionView: RecommendContentCollectionView, didSelectItemAt index: Int)
}

final class RecommendContentCollectionView: UICollectionView {

    // MARK: - Properties

    weak var contentDelegate: RecommendContentCollectionViewDelegate?

    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, Recommendation>?

    // MARK: - Initialization

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.itemSize = CGSize(width: 200, height: 260)

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
        showsHorizontalScrollIndicator = false
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 24)
        delegate = self
        register(RecommendContentCell.self, forCellWithReuseIdentifier: RecommendContentCell.identifier)
    }

    private func setupDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<Int, Recommendation>(
            collectionView: self
        ) { collectionView, indexPath, recommendation in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendContentCell.identifier,
                for: indexPath
            ) as? RecommendContentCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: recommendation)
            return cell
        }
    }

    // MARK: - Public Methods

    func applySnapshot(recommendations: [Recommendation]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Recommendation>()
        snapshot.appendSections([0])
        snapshot.appendItems(recommendations)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate

extension RecommendContentCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        contentDelegate?.recommendContentCollectionView(self, didSelectItemAt: indexPath.item)
    }
}
