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

    private var trips: [PopularTrip] = []
    private let maxItemCount = 3

    // MARK: - Initialization

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12

        super.init(frame: .zero, collectionViewLayout: layout)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupCollectionView() {
        backgroundColor = .clear
        isScrollEnabled = false
        dataSource = self
        delegate = self
        register(YoutuberContentCell.self, forCellWithReuseIdentifier: YoutuberContentCell.identifier)
    }

    // MARK: - Public Methods

    func configure(trips: [PopularTrip]) {
        self.trips = Array(trips.prefix(maxItemCount))
        reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension YoutuberContentCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: YoutuberContentCell.identifier,
            for: indexPath
        ) as? YoutuberContentCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: trips[indexPath.item])
        return cell
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
