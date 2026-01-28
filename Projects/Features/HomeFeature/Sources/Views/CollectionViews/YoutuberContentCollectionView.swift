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
    func youtuberContentCollectionView(_ collectionView: YoutuberContentCollectionView, didSelectItemAt index: Int, in section: Int)
    func youtuberContentCollectionView(_ collectionView: YoutuberContentCollectionView, didScrollToSection section: Int)
}

final class YoutuberContentCollectionView: UICollectionView {

    // MARK: - Properties

    weak var contentDelegate: YoutuberContentCollectionViewDelegate?

    private let maxItemCountPerSection = 3
    private let peekWidth: CGFloat = 10
    private var diffableDataSource: UICollectionViewDiffableDataSource<TripCategory, PopularTrip>?
    private var categories: [TripCategory] = []

    // MARK: - Initialization

    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionViewLayout = createLayout()
        setupCollectionView()
        setupDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }

            let containerWidth = environment.container.contentSize.width
            let sectionWidth = containerWidth - self.peekWidth

            // Item - 한 셀의 크기
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(88)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // Group - 세로로 3개씩 묶음
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(sectionWidth),
                heightDimension: .absolute(88 * 3 + 12 * 2)
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            group.interItemSpacing = .fixed(12)

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging

            return section
        }

        return layout
    }

    // MARK: - Setup

    private func setupCollectionView() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        delegate = self
        register(YoutuberContentCell.self, forCellWithReuseIdentifier: YoutuberContentCell.identifier)
    }

    private func setupDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<TripCategory, PopularTrip>(
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

    func applySnapshot(tripsByCategory: [TripCategory: [PopularTrip]], categories: [TripCategory]) {
        self.categories = categories

        var snapshot = NSDiffableDataSourceSnapshot<TripCategory, PopularTrip>()

        for category in categories {
            snapshot.appendSections([category])
            let trips = tripsByCategory[category] ?? []
            let limitedTrips = Array(trips.prefix(maxItemCountPerSection))
            snapshot.appendItems(limitedTrips, toSection: category)
        }

        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }

    func scrollToCategory(at index: Int, animated: Bool = true) {
        guard index < categories.count else { return }

        let indexPath = IndexPath(item: 0, section: index)
        scrollToItem(at: indexPath, at: .left, animated: animated)
    }
}

// MARK: - UICollectionViewDelegate

extension YoutuberContentCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        contentDelegate?.youtuberContentCollectionView(self, didSelectItemAt: indexPath.item, in: indexPath.section)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentSection()
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCurrentSection()
    }

    private func updateCurrentSection() {
        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        if let indexPath = indexPathForItem(at: visiblePoint) {
            contentDelegate?.youtuberContentCollectionView(self, didScrollToSection: indexPath.section)
        }
    }
}
