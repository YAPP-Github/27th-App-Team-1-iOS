//
//  PlanBCollectionView.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-02-10.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import DSKit
import SnapKit
import UIKit

// MARK: - PlanBCollectionView

final class PlanBCollectionView: UICollectionView {

    // MARK: - Properties

    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, PlanBInfo>?

    // MARK: - Initialization

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10

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
        register(PlanBCell.self, forCellWithReuseIdentifier: PlanBCell.identifier)
    }

    private func setupDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<Int, PlanBInfo>(
            collectionView: self
        ) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PlanBCell.identifier,
                for: indexPath
            ) as? PlanBCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: item)
            return cell
        }
    }

    // MARK: - Public Methods

    func applySnapshot(planBItems: [PlanBInfo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, PlanBInfo>()
        snapshot.appendSections([0])
        snapshot.appendItems(planBItems, toSection: 0)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }

    func calculateHeight(for itemCount: Int) -> CGFloat {
        let cellHeight: CGFloat = 70
        let spacing: CGFloat = 10
        return CGFloat(itemCount) * cellHeight + CGFloat(max(0, itemCount - 1)) * spacing
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PlanBCollectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
    }
}

// MARK: - PlanBCell

final class PlanBCell: UICollectionViewCell {

    static let identifier = "PlanBCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexCode: "#E5E5E5").cgColor
        return view
    }()

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = UIColor(hexCode: "#F0F0F0")
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(containerView)
        [thumbnailImageView, nameLabel].forEach {
            containerView.addSubview($0)
        }

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(16)
            $0.width.height.equalTo(38)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(thumbnailImageView.snp.bottom)
        }
    }

    func configure(with planB: PlanBInfo) {
        let attributedText = NSAttributedString(
            string: planB.name,
            attributes: UIFont.NDGL.bodyMM.attributes
        )
        nameLabel.attributedText = attributedText
    }
}
