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

    // MARK: - Properties

    weak var categoryDelegate: CategoryCollectionViewDelegate?

    private var categories: [String] = []
    private var selectedIndex: Int = 0

    // MARK: - Initialization

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        super.init(frame: .zero, collectionViewLayout: layout)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupCollectionView() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        dataSource = self
        delegate = self
        register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
    }

    // MARK: - Public Methods

    func configure(categories: [String], selectedIndex: Int = 0) {
        self.categories = categories
        self.selectedIndex = selectedIndex
        reloadData()
    }

    func selectCategory(at index: Int) {
        self.selectedIndex = index
        reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension CategoryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCell.identifier,
            for: indexPath
        ) as? CategoryCell else {
            return UICollectionViewCell()
        }

        let isSelected = indexPath.item == selectedIndex
        cell.configure(title: categories[indexPath.item], isSelected: isSelected)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CategoryCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 내부 상태 변경 없이 delegate에게만 알림
        // Interactor가 상태를 변경하고, configure()를 통해 UI가 업데이트됨
        categoryDelegate?.categoryCollectionView(self, didSelectCategoryAt: indexPath.item)
    }
}
