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
    private var isEditMode: Bool = false
    private var selectedIds: Set<Int> = []

    var isAllSelected: Bool {
        !places.isEmpty && selectedIds.count == places.count
    }

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
            guard let self,
                  let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PlaceCell.identifier,
                    for: indexPath
                  ) as? PlaceCell else {
                return UICollectionViewCell()
            }

            let isLast = indexPath.item == self.places.count - 1
            cell.configure(with: place, isLast: isLast)
            cell.setEditMode(self.isEditMode, isChecked: self.selectedIds.contains(place.id))

            cell.onContainerTapped = { [weak self, weak cell] in
                guard let self else { return }
                if self.isEditMode {
                    // 체크박스 토글
                    let isNowSelected = !self.selectedIds.contains(place.id)
                    if isNowSelected {
                        self.selectedIds.insert(place.id)
                    } else {
                        self.selectedIds.remove(place.id)
                    }
                    cell?.setEditMode(true, isChecked: isNowSelected)
                } else {
                    self.placeDelegate?.placeListCollectionView(self, didSelectPlace: place)
                }
            }

            cell.onDragHandlePan = { [weak self, weak cell] gesture in
                guard let self, let cell else { return }
                let location = gesture.location(in: self)
                switch gesture.state {
                case .began:
                    if let ip = self.indexPath(for: cell) {
                        self.beginInteractiveMovementForItem(at: ip)
                    }
                case .changed:
                    self.updateInteractiveMovementTargetPosition(location)
                case .ended:
                    self.endInteractiveMovement()
                default:
                    self.cancelInteractiveMovement()
                }
            }

            return cell
        }

        // 재정렬 핸들러 (iOS 14+)
        diffableDataSource?.reorderingHandlers.canReorderItem = { [weak self] _ in
            return self?.isEditMode ?? false
        }
        diffableDataSource?.reorderingHandlers.didReorder = { [weak self] transaction in
            self?.places = transaction.finalSnapshot.itemIdentifiers(inSection: 0)
        }
    }

    // MARK: - Public Methods

    func setEditMode(_ isEditing: Bool) {
        isEditMode = isEditing
        if !isEditing {
            selectedIds.removeAll()
        }
        for cell in visibleCells.compactMap({ $0 as? PlaceCell }) {
            if let indexPath = indexPath(for: cell) {
                let place = places[indexPath.item]
                cell.setEditMode(isEditing, isChecked: isEditing && selectedIds.contains(place.id))
            }
        }
    }

    /// 전체 선택/해제 토글. 전체 선택 상태가 되면 true 반환.
    func toggleSelectAll() -> Bool {
        if isAllSelected {
            selectedIds.removeAll()
        } else {
            selectedIds = Set(places.map { $0.id })
        }
        for cell in visibleCells.compactMap({ $0 as? PlaceCell }) {
            if let indexPath = indexPath(for: cell) {
                let place = places[indexPath.item]
                cell.setEditMode(true, isChecked: selectedIds.contains(place.id))
            }
        }
        return isAllSelected
    }

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
