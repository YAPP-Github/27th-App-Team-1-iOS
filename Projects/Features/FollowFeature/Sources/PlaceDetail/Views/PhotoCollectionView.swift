//
//  PhotoCollectionView.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-02-10.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import DSKit
import Kingfisher
import SnapKit
import UIKit

// MARK: - PhotoCollectionView

final class PhotoCollectionView: UICollectionView {

    // MARK: - Types

    struct PhotoItem: Hashable {
        let index: Int
        let photoURL: String
        let width: Int
        let height: Int
    }

    // MARK: - Properties

    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, PhotoItem>?
    private var photoItems: [PhotoItem] = []

    // MARK: - Initialization

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8

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
        showsVerticalScrollIndicator = false
        isScrollEnabled = false
        delegate = self
        register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
    }

    private func setupDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<Int, PhotoItem>(
            collectionView: self
        ) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoCell.identifier,
                for: indexPath
            ) as? PhotoCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: item.photoURL)
            return cell
        }
    }

    // MARK: - Public Methods

    func applySnapshot(photos: [PlacePhoto]) {
        photoItems = photos.enumerated().map {
            PhotoItem(
                index: $0.offset,
                photoURL: $0.element.photoUri,
                width: $0.element.widthPx,
                height: $0.element.heightPx
            )
        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, PhotoItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(photoItems, toSection: 0)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }

    func calculateTotalHeight() -> CGFloat {
        guard !photoItems.isEmpty else { return 0 }

        let cellWidth = calculateCellWidth()
        guard cellWidth > 0 else { return 0 }

        var leftColumnHeight: CGFloat = 0
        var rightColumnHeight: CGFloat = 0
        let spacing: CGFloat = 8

        for (index, item) in photoItems.enumerated() {
            // 0으로 나누기 방지
            guard item.width > 0 else { continue }
            let aspectRatio = CGFloat(item.height) / CGFloat(item.width)
            let cellHeight = cellWidth * aspectRatio

            if index % 2 == 0 {
                leftColumnHeight += cellHeight + spacing
            } else {
                rightColumnHeight += cellHeight + spacing
            }
        }

        let totalHeight = max(leftColumnHeight, rightColumnHeight) - spacing
        return max(totalHeight, 0)
    }

    private func calculateCellWidth() -> CGFloat {
        let totalWidth = frame.width
        guard totalWidth > 0 else { return 100 } // 레이아웃 전 기본값
        let horizontalPadding: CGFloat = 24 * 2
        let interItemSpacing: CGFloat = 8
        let width = (totalWidth - horizontalPadding - interItemSpacing) / 2
        return max(width, 1) // 음수 방지
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoCollectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellWidth = calculateCellWidth()

        guard indexPath.item < photoItems.count else {
            return CGSize(width: cellWidth, height: cellWidth)
        }

        let item = photoItems[indexPath.item]
        // 0으로 나누기 방지
        guard item.width > 0 else {
            return CGSize(width: cellWidth, height: cellWidth)
        }
        let aspectRatio = CGFloat(item.height) / CGFloat(item.width)
        let cellHeight = cellWidth * aspectRatio

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
}

// MARK: - PhotoCell

final class PhotoCell: UICollectionViewCell {

    static let identifier = "PhotoCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = DSKitAsset.Colors.white.color
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame )
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(imageView)

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configure(with photoURL: String) {
        guard let url = URL(string: photoURL) else { return }
        imageView.kf.setImage(
            with: url,
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage,
                .backgroundDecode // 백그라운드에서 디코딩
            ]
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask() // 진행 중인 다운로드 취소
        imageView.image = nil
    }
}
