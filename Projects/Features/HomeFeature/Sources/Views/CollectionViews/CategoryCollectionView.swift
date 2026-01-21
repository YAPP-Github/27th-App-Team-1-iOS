//
//  CategoryCollectionView.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-22.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

protocol CategoryCollectionViewDelegate: AnyObject {
    func categoryCollectionView(_ collectionView: CategoryCollectionView, didSelectCategoryAt index: Int)
}

final class CategoryCollectionView: UICollectionView {

    // MARK: - Models

    private struct CategoryItem: Hashable {
        let index: Int
        let title: String
        let isSelected: Bool
        let isFirstItem: Bool
    }

    // MARK: - Properties

    weak var categoryDelegate: CategoryCollectionViewDelegate?

    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, CategoryItem>?

    // MARK: - Initialization

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
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
        showsHorizontalScrollIndicator = false
        delegate = self
        register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
    }

    private func setupDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<Int, CategoryItem>(
            collectionView: self
        ) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryCell.identifier,
                for: indexPath
            ) as? CategoryCell else {
                return UICollectionViewCell()
            }
            cell.configure(title: item.title, isSelected: item.isSelected, isFirstItem: item.isFirstItem)
            return cell
        }
    }

    // MARK: - Public Methods

    func applySnapshot(categories: [String], selectedIndex: Int) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CategoryItem>()
        snapshot.appendSections([0])

        let items = categories.enumerated().map { index, title in
            CategoryItem(
                index: index,
                title: title,
                isSelected: index == selectedIndex,
                isFirstItem: index == 0
            )
        }
        snapshot.appendItems(items)

        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate

extension CategoryCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryDelegate?.categoryCollectionView(self, didSelectCategoryAt: indexPath.item)
    }
}
