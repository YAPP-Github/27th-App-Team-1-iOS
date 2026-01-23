//
//  DayCollectionView.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

protocol DayCollectionViewDelegate: AnyObject {
    func dayCollectionView(_ collectionView: DayCollectionView, didSelectDay day: Int)
}

final class DayCollectionView: UICollectionView {

    // MARK: - Types

    struct DayItem: Hashable {
        let day: Int
    }

    // MARK: - Properties

    weak var dayDelegate: DayCollectionViewDelegate?
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, DayItem>?
    private var totalDays: Int = 0

    // MARK: - Initialization

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 60, height: 32)

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
        delegate = self
        register(DayCell.self, forCellWithReuseIdentifier: DayCell.identifier)
    }

    private func setupDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<Int, DayItem>(
            collectionView: self
        ) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DayCell.identifier,
                for: indexPath
            ) as? DayCell else {
                return UICollectionViewCell()
            }
            cell.configure(day: item.day)
            return cell
        }
    }

    // MARK: - Public Methods

    func applySnapshot(totalDays: Int, selectedDay: Int = 1) {
        self.totalDays = totalDays

        var snapshot = NSDiffableDataSourceSnapshot<Int, DayItem>()
        snapshot.appendSections([0])

        let items = (1...totalDays).map { DayItem(day: $0) }
        snapshot.appendItems(items, toSection: 0)

        diffableDataSource?.apply(snapshot, animatingDifferences: false) { [weak self] in
            // 선택 상태 설정
            let indexPath = IndexPath(item: selectedDay - 1, section: 0)
            self?.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension DayCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = indexPath.item + 1
        dayDelegate?.dayCollectionView(self, didSelectDay: day)
    }
}
