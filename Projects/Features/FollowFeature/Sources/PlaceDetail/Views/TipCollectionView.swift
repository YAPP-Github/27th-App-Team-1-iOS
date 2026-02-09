//
//  TipCollectionView.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-02-10.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import DSKit
import SnapKit
import UIKit

// MARK: - TipCollectionViewDelegate

protocol TipCollectionViewDelegate: AnyObject {
    func tipCollectionView(_ collectionView: TipCollectionView, didScrollToPage page: Int)
}

// MARK: - TipCollectionView

final class TipCollectionView: UICollectionView {

    // MARK: - Types

    struct TipItem: Hashable {
        let index: Int
        let tip: String
        let youtuberName: String
    }

    // MARK: - Properties

    weak var tipDelegate: TipCollectionViewDelegate?
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, TipItem>?

    // MARK: - Initialization

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
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
        showsHorizontalScrollIndicator = false
        isPagingEnabled = false
        decelerationRate = .fast
        delegate = self
        contentInset = UIEdgeInsets(top: 0, left: 37, bottom: 0, right: 37)
        register(TipCell.self, forCellWithReuseIdentifier: TipCell.identifier)
    }

    private func setupDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<Int, TipItem>(
            collectionView: self
        ) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TipCell.identifier,
                for: indexPath
            ) as? TipCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: item.tip, youtuberName: item.youtuberName)
            return cell
        }
    }

    // MARK: - Properties (Public)

    private(set) var totalTipsCount: Int = 0

    // MARK: - Public Methods

    func applySnapshot(tips: [String], youtuberName: String) {
        totalTipsCount = tips.count

        var snapshot = NSDiffableDataSourceSnapshot<Int, TipItem>()
        snapshot.appendSections([0])
        let items = tips.enumerated().map {
            TipItem(index: $0.offset, tip: $0.element, youtuberName: youtuberName)
        }
        snapshot.appendItems(items, toSection: 0)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TipCollectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.frame.width - 37 - 10 - 27
        return CGSize(width: width, height: collectionView.frame.height)
    }

    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let cellWidth = scrollView.frame.width - 37 - 10 - 27
        let spacing: CGFloat = 10
        let cellWidthWithSpacing = cellWidth + spacing

        var offset = targetContentOffset.pointee.x + 37
        let index = round(offset / cellWidthWithSpacing)
        offset = index * cellWidthWithSpacing - 37

        targetContentOffset.pointee = CGPoint(x: offset, y: 0)

        tipDelegate?.tipCollectionView(self, didScrollToPage: Int(index))
    }
}

// MARK: - TipCell

final class TipCell: UICollectionViewCell {

    static let identifier = "TipCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "#F5F5F7")
        view.layer.cornerRadius = 16
        return view
    }()

    // "콘텐츠 속 꿀팁" badge
    private let categoryLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.backgroundColor = UIColor(hexCode: "#E8E8EC")
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        label.padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return label
    }()

    // "유튜버의 꿀팁" title
    private let youtuberTipLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private let tipLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
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
        [categoryLabel, youtuberTipLabel, tipLabel].forEach {
            containerView.addSubview($0)
        }

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }

        youtuberTipLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }

        tipLabel.snp.makeConstraints {
            $0.top.equalTo(youtuberTipLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }

    func configure(with tip: String, youtuberName: String) {
        // Category badge
        let categoryText = NSAttributedString(
            string: "콘텐츠 속 꿀팁",
            attributes: UIFont.NDGL.bodySM.attributes
        )
        categoryLabel.attributedText = categoryText

        // Youtuber title
        let youtuberText = NSAttributedString(
            string: "\(youtuberName)의 꿀팁",
            attributes: UIFont.NDGL.bodyLSB.attributes
        )
        youtuberTipLabel.attributedText = youtuberText

        // Tip text
        let tipText = NSAttributedString(
            string: "\"\(tip)\"",
            attributes: UIFont.NDGL.bodyLR.attributes
        )
        tipLabel.attributedText = tipText
    }
}

// MARK: - PaddingLabel

final class PaddingLabel: UILabel {

    var padding = UIEdgeInsets.zero

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + padding.left + padding.right,
            height: size.height + padding.top + padding.bottom
        )
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSize = super.sizeThatFits(size)
        return CGSize(
            width: superSize.width + padding.left + padding.right,
            height: superSize.height + padding.top + padding.bottom
        )
    }
}
